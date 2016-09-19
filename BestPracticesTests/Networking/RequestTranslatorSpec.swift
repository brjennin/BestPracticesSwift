import Quick
import Nimble
import Fleet
import Alamofire
@testable import BestPractices

class RequestTranslatorSpec: QuickSpec {
    override func spec() {
        
        var subject: RequestTranslator!
        var params: [String: AnyObject]?
        var headers: [String: String]?
        let urlString = "url"
        let method = HTTPMethod.GET
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
                        result = subject.translateRequestForAlamofire(originRequest)
                    }
                    
                    it("returns an Alamofire request") {
                        expect(result).toNot(beNil())
                        expect(result.request!.HTTPMethod!).to(equal("GET"))
                        expect(result.request!.URL!.absoluteString).to(equal("url"))
                        expect(result.request?.allHTTPHeaderFields).to(beEmpty())
                    }
                }
                
                context("When there are headers") {
                    beforeEach {
                        headers = ["Header-Thing": "Value"]
                        originRequest = HTTPRequest(urlString: urlString, httpMethod: method, params: params, headers: headers)
                        result = subject.translateRequestForAlamofire(originRequest)
                    }
                    
                    it("returns an Alamofire request") {
                        expect(result).toNot(beNil())
                        expect(result.request!.HTTPMethod!).to(equal("GET"))
                        expect(result.request!.URL!.absoluteString).to(equal("url"))
                        expect(result.request?.allHTTPHeaderFields!).to(equal(headers))
                    }
                }
            }
            
            context("When there are params") {
                beforeEach {
                    params = ["Key": 3, "Other": "thing"]
                }
                
                context("When no headers") {
                    beforeEach {
                        headers = nil
                        originRequest = HTTPRequest(urlString: urlString, httpMethod: method, params: params, headers: headers)
                        result = subject.translateRequestForAlamofire(originRequest)
                    }
                    
                    it("returns an Alamofire request") {
                        expect(result).toNot(beNil())
                        expect(result.request!.HTTPMethod!).to(equal("GET"))
                        expect(result.request!.URL!.absoluteString).to(equal("url?Key=3&Other=thing"))
                        expect(result.request?.allHTTPHeaderFields).to(beEmpty())
                    }
                }
                
                context("When there are headers") {
                    beforeEach {
                        headers = ["Header-Thing": "Value"]
                        originRequest = HTTPRequest(urlString: urlString, httpMethod: method, params: params, headers: headers)
                        result = subject.translateRequestForAlamofire(originRequest)
                    }
                    
                    it("returns an Alamofire request") {
                        expect(result).toNot(beNil())
                        expect(result.request!.HTTPMethod!).to(equal("GET"))
                        expect(result.request!.URL!.absoluteString).to(equal("url?Key=3&Other=thing"))
                        expect(result.request?.allHTTPHeaderFields!).to(equal(headers))
                    }
                }
            }
        }
    }
}
