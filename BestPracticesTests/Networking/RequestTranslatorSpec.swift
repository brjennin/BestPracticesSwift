import Quick
import Nimble
import Alamofire
@testable import BestPractices

class RequestTranslatorSpec: QuickSpec {
    override func spec() {
        
        var subject: RequestTranslator!
        var params: [String: AnyObject]?
        var headers: [String: String]?
        let urlString = "url"
        let method = HTTPMethod.get
        var originRequest: HTTPRequest!
        var result: Request!
        
        beforeEach {
            subject = RequestTranslator()
        }
        
        describe(".translateRequestForAlamofire") {
            context("When no params") {
                beforeEach {
                    params = nil
                }
                
                context("When no headers") {
                    beforeEach {
                        headers = nil
                         originRequest = HTTPRequest(urlString: urlString, httpMethod: method, params: params, headers: headers)
                        result = subject.translateRequestForAlamofire(request: originRequest)
                    }
                    
                    it("returns an Alamofire request") {
                        expect(result).toNot(beNil())
                        expect(result.request!.httpMethod!).to(equal("GET"))
                        expect(result.request!.url!.absoluteString).to(equal("url"))
                        expect(result.request?.allHTTPHeaderFields).to(beEmpty())
                    }
                }
                
                context("When there are headers") {
                    beforeEach {
                        headers = ["Header-Thing": "Value"]
                        originRequest = HTTPRequest(urlString: urlString, httpMethod: method, params: params, headers: headers)
                        result = subject.translateRequestForAlamofire(request: originRequest)
                    }
                    
                    it("returns an Alamofire request") {
                        expect(result).toNot(beNil())
                        expect(result.request!.httpMethod!).to(equal("GET"))
                        expect(result.request!.url!.absoluteString).to(equal("url"))
                        expect(result.request?.allHTTPHeaderFields!).to(equal(headers))
                    }
                }
            }
            
            context("When there are params") {
                beforeEach {
                    params = ["Key": "anyting" as AnyObject!, "Other": "thing" as AnyObject!]
                }
                
                context("When no headers") {
                    beforeEach {
                        headers = nil
                        originRequest = HTTPRequest(urlString: urlString, httpMethod: method, params: params, headers: headers)
                        result = subject.translateRequestForAlamofire(request: originRequest)
                    }
                    
                    it("returns an Alamofire request") {
                        expect(result).toNot(beNil())
                        expect(result.request!.httpMethod!).to(equal("GET"))
                        expect(result.request!.url!.absoluteString).to(equal("url?Key=anyting&Other=thing"))
                        expect(result.request?.allHTTPHeaderFields).to(beEmpty())
                    }
                }
                
                context("When there are headers") {
                    beforeEach {
                        headers = ["Header-Thing": "Value"]
                        originRequest = HTTPRequest(urlString: urlString, httpMethod: method, params: params, headers: headers)
                        result = subject.translateRequestForAlamofire(request: originRequest)
                    }
                    
                    it("returns an Alamofire request") {
                        expect(result).toNot(beNil())
                        expect(result.request!.httpMethod!).to(equal("GET"))
                        expect(result.request!.url!.absoluteString).to(equal("url?Key=anyting&Other=thing"))
                        expect(result.request?.allHTTPHeaderFields!).to(equal(headers))
                    }
                }
            }
        }
    }
}
