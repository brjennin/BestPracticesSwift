import Quick
import Nimble
import Alamofire
@testable import BestPractices

class HTTPRequestSpec: QuickSpec {
    override func spec() {
        
        var subject: HTTPRequest!
        let params = ["Key": "ting", "Other": "thing"]
        let headers = ["Header-Thing": "Value"]
        
        beforeEach {
            subject = HTTPRequest(urlString: "url", httpMethod: HTTPMethod.get, params: params as [String : AnyObject]?, headers: headers)
        }
        
        it("stores off the values it is initialized with in properties") {
            expect(subject.urlString).to(equal("url"))
            expect(subject.httpMethod).to(equal(HTTPMethod.get))
            expect((subject.params!["Key"] as! String)).to(equal("ting"))
            expect((subject.params!["Other"] as! String)).to(equal("thing"))
            expect(subject.headers!).to(equal(headers))
        }
        
    }
}
