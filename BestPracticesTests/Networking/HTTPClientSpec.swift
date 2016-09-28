import Quick
import Nimble
import SwiftyJSON
import Mockingjay
import Alamofire
@testable import BestPractices

class HTTPClientSpec: QuickSpec {

    override func spec() {

        var subject: HTTPClient!
        var requestTranslator: MockRequestTranslator!
        var diskMaster: MockDiskMaster!
        var activityIndicator: MockActivityIndicator!

        beforeEach {
            subject = HTTPClient()

            requestTranslator = MockRequestTranslator()
            subject.requestTranslator = requestTranslator

            diskMaster = MockDiskMaster()
            subject.diskMaster = diskMaster

            activityIndicator = MockActivityIndicator()
            subject.activityIndicator = activityIndicator
        }

        sharedExamples("displaying network activity") {
            it("started the activity indicator") {
                expect(activityIndicator.calledStart).to(beTruthy())
            }

            it("stopped the activity indicator") {
                expect(activityIndicator.calledStop).toEventually(beTruthy())
            }

            it("is not currently spinning") {
                expect(activityIndicator.spinning).toEventually(beFalsy())
            }
        }

        xdescribe(".makeJsonRequest") {
            var returnedJSON: JSON?
            var returnedError: NSError?
            var completionCalled: Bool!
            var request: HTTPRequest!
            var completion: ((JSON?, NSError?) -> ())!

            beforeEach {
                completion = { json, error in
                    completionCalled = true
                    returnedJSON = json
                    returnedError = error
                }
                completionCalled = false
                request = HTTPRequest(urlString: "urlstring", httpMethod: HTTPMethod.get, params: nil, headers: nil)
            }

            context("When a 200 response code") {
                context("With JSON") {
                    beforeEach {
                        self.stub(uri("translatedURL"), json(["key": "val"], status: 200))
                        subject.makeJsonRequest(request: request, completion: completion)
                    }

                    itBehavesLike("displaying network activity")

                    it("translates the request into an Alamofire request") {
                        expect(requestTranslator.calledTranslate).to(beTruthy())
                        expect(requestTranslator.capturedRequest!.urlString).to(equal("urlstring"))
                    }

                    it("returns json") {
                        expect(completionCalled).toEventually(beTruthy())
                        expect(returnedJSON).toEventuallyNot(beNil())
                        expect(returnedJSON).toEventually(equal(JSON(["key": "val"])))
                    }

                    it("does not send an error") {
                        expect(returnedError).to(beNil())
                    }
                }

                context("Without JSON") {
                    beforeEach {
                        self.stub(uri("translatedURL"), http(200))
                        subject.makeJsonRequest(request: request, completion: completion)
                    }

                    itBehavesLike("displaying network activity")

                    it("translates the request into an Alamofire request") {
                        expect(requestTranslator.calledTranslate).to(beTruthy())
                        expect(requestTranslator.capturedRequest!.urlString).to(equal("urlstring"))
                    }

                    it("returns nil for json") {
                        expect(completionCalled).toEventually(beTruthy())
                        expect(returnedJSON).toEventually(beNil())
                    }

                    it("sends along the error") {
                        expect(returnedError).toNot(beNil())
                    }
                }
            }

            context("When a non-200 response code") {
                beforeEach {
                    self.stub(uri("translatedURL"), json(["key": "val"], status: 300))
                    subject.makeJsonRequest(request: request, completion: completion)
                }

                itBehavesLike("displaying network activity")

                it("translates the request into an Alamofire request") {
                    expect(requestTranslator.calledTranslate).to(beTruthy())
                    expect(requestTranslator.capturedRequest!.urlString).to(equal("urlstring"))
                }

                it("returns nil for the json") {
                    expect(completionCalled).toEventually(beTruthy())
                    expect(returnedJSON).toEventually(beNil())
                }

                it("returns the error") {
                    expect(returnedError).toNot(beNil())
                }
            }

            context("When there is a server error") {
                beforeEach {
                    let error = NSError(domain: "com.error.thing", code: 500, userInfo: nil)
                    self.stub(uri("translatedURL"), failure(error))
                    subject.makeJsonRequest(request: request, completion: completion)
                }

                itBehavesLike("displaying network activity")

                it("translates the request into an Alamofire request") {
                    expect(requestTranslator.calledTranslate).to(beTruthy())
                    expect(requestTranslator.capturedRequest!.urlString).to(equal("urlstring"))
                }

                it("returns nil for the json") {
                    expect(completionCalled).toEventually(beTruthy())
                    expect(returnedJSON).toEventually(beNil())
                }

                it("returns the error") {
                    expect(returnedError!.code).to(equal(500))
                }
            }
        }

        xdescribe(".downloadFile") {
            let bundle = Bundle(for: type(of: self))
            let path = bundle.path(forResource: "maneater", ofType: "mp3")!
            let url = URL(fileURLWithPath: path)
            let sampleData = try! Data(contentsOf: url)
            let download = Download.content(sampleData)
            
            let fileManager = FileManager.default
            let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let testFile = directoryURL.appendingPathComponent("tests/testfile.example")

            context("When a 200 response code") {
                beforeEach {
                    self.stub(uri("dataURL"), http(200, headers: nil, download: download))
                }

                it("returns a url") {
                    var completionCalled = false

                    waitUntil { done in
                        subject.downloadFile(url: "dataURL", folderPath: "something/or/other/", completion: { url in
                            completionCalled = true
                        
                            expect(diskMaster.calledMediaURLForSongWithFilename).to(beTruthy())
                            expect(diskMaster.capturedFolderForMediaURL!).to(equal("something/or/other/"))
                            expect(diskMaster.capturedFilenameForMediaURL!).to(equal("dataURL.mp3"))
                            expect(url).to(equal(testFile))
                            expect(fileManager.fileExists(atPath: url!.path)).to(beTruthy())
                            expect(try! Data(contentsOf: url!)).to(equal(sampleData))

                            done()
                        })
                    }

                    expect(completionCalled).toEventually(beTruthy())
                    expect(activityIndicator.calledStart).to(beTruthy())
                    expect(activityIndicator.calledStop).toEventually(beTruthy())
                    expect(activityIndicator.spinning).toEventually(beFalsy())
                }
            }

            context("When a non-200 response code") {
                beforeEach {
                    self.stub(uri("dataURL"), http(300, headers: nil, download: download))
                }

                it("returns nil for the URL") {
                    var completionCalled = false

                    waitUntil { done in
                        subject.downloadFile(url: "dataURL", folderPath: "something/or/other/", completion: {url in
                            completionCalled = true
                            expect(url).to(beNil())
                            done()
                        })
                    }

                    expect(completionCalled).toEventually(beTruthy())
                    expect(activityIndicator.calledStart).to(beTruthy())
                    expect(activityIndicator.calledStop).toEventually(beTruthy())
                    expect(activityIndicator.spinning).toEventually(beFalsy())
                }
            }

            context("When there is a server error") {
                beforeEach {
                    let error = NSError(domain: "com.error.thing", code: 500, userInfo: nil)
                    self.stub(uri("dataURL"), failure(error))
                }

                it("returns nil for the URL") {
                    var completionCalled = false

                    waitUntil { done in
                        subject.downloadFile(url: "dataURL", folderPath: "something/or/other/", completion: {url in
                            completionCalled = true
                            expect(url).to(beNil())
                            done()
                        })
                    }

                    expect(completionCalled).toEventually(beTruthy())
                    expect(activityIndicator.calledStart).to(beTruthy())
                    expect(activityIndicator.calledStop).toEventually(beTruthy())
                    expect(activityIndicator.spinning).toEventually(beFalsy())
                }
            }
        }

    }
}
