import Quick
import Nimble
import Fleet
import SwiftyJSON
import Mockingjay
@testable import BestPractices

class HTTPClientSpec: QuickSpec {

    override func spec() {
        
        var subject: HTTPClient!
        var requestTranslator: MockRequestTranslator!
        
        beforeEach {
            subject = HTTPClient()
            
            requestTranslator = MockRequestTranslator()
            subject.requestTranslator = requestTranslator
        }
        
        describe(".makeJsonRequest") {
            var returnedJSON: JSON?
            var completionCalled: Bool!
            var request: HTTPRequest!
            var completion: ((JSON?) -> ())!
            
            beforeEach {
                completion = { json in
                    completionCalled = true
                    returnedJSON = json
                }
                returnedJSON = nil
                completionCalled = false
                request = HTTPRequest(urlString: "urlstring", httpMethod: HTTPMethod.GET, params: nil, headers: nil)
            }

            context("When a 200 response code") {
                context("With JSON") {
                    beforeEach {
                        self.stub(uri("translatedURL"), builder: json(["key": "val"], status: 200))
                        subject.makeJsonRequest(request, completion: completion)
                    }
                    
                    it("translates the request into an Alamofire request") {
                        expect(requestTranslator.calledTranslate).to(beTruthy())
                        expect(requestTranslator.capturedRequest!.urlString).to(equal("urlstring"))
                    }
                    
                    it("returns json") {
                        expect(completionCalled).toEventually(beTruthy())
                        expect(returnedJSON).toEventuallyNot(beNil())
                        expect(returnedJSON).toEventually(equal(JSON(["key": "val"])))
                    }
                }
                
                context("Without JSON") {
                    beforeEach {
                        self.stub(uri("translatedURL"), builder: http(200))
                        subject.makeJsonRequest(request, completion: completion)
                    }
                    
                    it("translates the request into an Alamofire request") {
                        expect(requestTranslator.calledTranslate).to(beTruthy())
                        expect(requestTranslator.capturedRequest!.urlString).to(equal("urlstring"))
                    }
                    
                    it("returns nil for json") {
                        expect(completionCalled).toEventually(beTruthy())
                        expect(returnedJSON).toEventually(beNil())
                    }
                }
            }
            
            context("When a non-200 response code") {
                beforeEach {
                    self.stub(uri("translatedURL"), builder: json(["key": "val"], status: 300))
                    subject.makeJsonRequest(request, completion: completion)
                }
                
                it("translates the request into an Alamofire request") {
                    expect(requestTranslator.calledTranslate).to(beTruthy())
                    expect(requestTranslator.capturedRequest!.urlString).to(equal("urlstring"))
                }
                
                it("returns nil for the json") {
                    expect(completionCalled).toEventually(beTruthy())
                    expect(returnedJSON).toEventually(beNil())
                }
            }
            
            context("When there is a server error") {
                beforeEach {
                    let error = NSError(domain: "com.error.thing", code: 500, userInfo: nil)
                    self.stub(uri("translatedURL"), builder: failure(error))
                    subject.makeJsonRequest(request, completion: completion)
                }
                
                it("translates the request into an Alamofire request") {
                    expect(requestTranslator.calledTranslate).to(beTruthy())
                    expect(requestTranslator.capturedRequest!.urlString).to(equal("urlstring"))
                }
                
                it("returns nil for the json") {
                    expect(completionCalled).toEventually(beTruthy())
                    expect(returnedJSON).toEventually(beNil())
                }
            }
        }
        
    }
}
