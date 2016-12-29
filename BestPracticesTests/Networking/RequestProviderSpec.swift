import Quick
import Nimble
import Alamofire
@testable import BestPractices

class RequestProviderSpec: QuickSpec {
    override func spec() {
        
        var subject: RequestProvider!
        
        beforeEach {
            subject = RequestProvider()
        }
        
        describe(".getSoundsListRequest") {
            var result: HTTPRequest!
            
            beforeEach {
                result = subject.getSoundsListRequest()
            }
            
            it("returns a request") {
                expect(result.urlString).to(equal("https://yachty.herokuapp.com/api/v1/songs"))
                expect(result.httpMethod).to(equal(HTTPMethod.get))
                expect(result.params).to(beNil())
                expect(result.headers).to(beNil())
            }
        }
        
    }
}
