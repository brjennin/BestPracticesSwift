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

        var completionCalled: Bool!
        
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
                expect(activityIndicator.calledStop).toEventually(beTruthy())
                expect(activityIndicator.spinning).toEventually(beFalsy())
                expect(completionCalled).toEventually(beTruthy())
            }
        }

        describe(".makeJsonRequest") {
            var expectedJSON: JSON?
            var expectedError: NSError?
            
            var request: HTTPRequest!
            var completion: ((JSON?, NSError?) -> ())!

            beforeEach {
                expectedJSON = nil
                expectedError = nil
                completionCalled = false
                
                completion = { json, error in
                    completionCalled = true

                    if let expJSON = expectedJSON {
                        expect(json).to(equal(expJSON));
                    } else {
                        expect(json).to(beNil());
                    }
                    if let expError = expectedError {
                        expect(error).to(equal(expError));
                    } else {
                        expect(error).to(beNil());
                    }
                }
                request = HTTPRequest(urlString: "urlstring", httpMethod: HTTPMethod.get, params: nil, headers: nil)
            }

            context("When a 200 response code") {
                context("With JSON") {
                    beforeEach {
                        requestTranslator.returnValueForRequestTranslation = "translatedURL1"
                        self.stub(uri("translatedURL1"), json(["key": "val"], status: 200))
                        
                        expectedJSON = JSON(["key": "val"])
                        expectedError = nil
                        
                        subject.makeJsonRequest(request: request, completion: completion)
                    }

                    itBehavesLike("displaying network activity")

                    it("translates the request into an Alamofire request") {
                        expect(requestTranslator.calledTranslate).to(beTruthy())
                        expect(requestTranslator.capturedRequest!.urlString).to(equal("urlstring"))
                        expect(completionCalled).toEventually(beTruthy())
                    }
                }

                context("Without JSON") {
                    beforeEach {
                        requestTranslator.returnValueForRequestTranslation = "translatedURL2"
                        self.stub(uri("translatedURL2"), http(200))
                        
                        expectedJSON = nil
                        expectedError = NSError(domain: "Alamofire.AFError", code: 4, userInfo: nil);
                        
                        subject.makeJsonRequest(request: request, completion: completion)
                    }

                    itBehavesLike("displaying network activity")

                    it("translates the request into an Alamofire request") {
                        expect(requestTranslator.calledTranslate).to(beTruthy())
                        expect(requestTranslator.capturedRequest!.urlString).to(equal("urlstring"))
                        expect(completionCalled).toEventually(beTruthy())
                    }
                }
            }

            context("When a non-200 response code") {
                beforeEach {
                    requestTranslator.returnValueForRequestTranslation = "translatedURL3"
                    self.stub(uri("translatedURL3"), json(["key": "val"], status: 300))
                    
                    expectedJSON = nil
                    expectedError = NSError(domain: "Alamofire.AFError", code: 3, userInfo: nil);
                    
                    subject.makeJsonRequest(request: request, completion: completion)
                }

                itBehavesLike("displaying network activity")

                it("translates the request into an Alamofire request") {
                    expect(requestTranslator.calledTranslate).to(beTruthy())
                    expect(requestTranslator.capturedRequest!.urlString).to(equal("urlstring"))
                    expect(completionCalled).toEventually(beTruthy())
                }
            }

            context("When there is a server error") {
                beforeEach {
                    requestTranslator.returnValueForRequestTranslation = "translatedURL4"
                    let error = NSError(domain: "com.error.thing", code: 500, userInfo: nil)
                    self.stub(uri("translatedURL4"), failure(error))
                    
                    expectedJSON = nil
                    expectedError = error
                    
                    subject.makeJsonRequest(request: request, completion: completion)
                }

                itBehavesLike("displaying network activity")

                it("translates the request into an Alamofire request") {
                    expect(requestTranslator.calledTranslate).to(beTruthy())
                    expect(requestTranslator.capturedRequest!.urlString).to(equal("urlstring"))
                    expect(completionCalled).toEventually(beTruthy())
                }
            }
        }

        describe(".downloadFile") {
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
                        
                            expect(diskMaster.calledMediaURLForFileWithFilename).to(beTruthy())
                            expect(diskMaster.capturedFolderForMediaURL!).to(equal("something/or/other/"))
                            expect(diskMaster.capturedFilenameForMediaURL!).to(equal("dataURL.mp3"))
                            expect(url).to(equal(testFile))
                            expect(fileManager.fileExists(atPath: url!.path)).to(beTruthy())
                            expect(try! Data(contentsOf: url!)).to(equal(sampleData))

                            done()
                        })
                    }

                    expect(activityIndicator.calledStart).to(beTruthy())
                    expect(activityIndicator.calledStop).toEventually(beTruthy())
                    expect(activityIndicator.spinning).toEventually(beFalsy())
                    expect(completionCalled).toEventually(beTruthy())
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
                    
                    expect(activityIndicator.calledStart).to(beTruthy())
                    expect(activityIndicator.calledStop).toEventually(beTruthy())
                    expect(activityIndicator.spinning).toEventually(beFalsy())
                    expect(completionCalled).toEventually(beTruthy())
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

                    expect(activityIndicator.calledStart).to(beTruthy())
                    expect(activityIndicator.calledStop).toEventually(beTruthy())
                    expect(activityIndicator.spinning).toEventually(beFalsy())
                    expect(completionCalled).toEventually(beTruthy())
                }
            }
        }

    }
}
