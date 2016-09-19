import Quick
import Nimble
import Fleet
@testable import BestPractices

class HTTPRequestSpec: QuickSpec {
    override func spec() {
        
        var subject: HTTPRequest!
        let params = ["Key": 3, "Other": "thing"]
        let headers = ["Header-Thing": "Value"]
        
        beforeEach {
            subject = HTTPRequest(urlString: "url", httpMethod: HTTPMethod.GET, params: params, headers: headers)
        }
        
        it("stores off the values it is initialized with in properties") {
            expect(subject.urlString).to(equal("url"))
            expect(subject.httpMethod).to(equal(HTTPMethod.GET))
            expect((subject.params!["Key"] as! Int)).to(equal(3))
            expect((subject.params!["Other"] as! String)).to(equal("thing"))
            expect(subject.headers!).to(equal(headers))
        }
        
    }
}
