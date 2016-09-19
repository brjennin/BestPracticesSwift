import Quick
import Nimble
import Fleet
@testable import BestPractices

class RequestProviderSpec: QuickSpec {
    override func spec() {
        
        var subject: RequestProvider!
        
        beforeEach {
            subject = RequestProvider()
        }
        
        describe(".getSongsListRequest") {
            var result: HTTPRequest!
            
            beforeEach {
                result = subject.getSongsListRequest()
            }
            
            it("returns a request") {
                expect(result.urlString).to(equal("https://pockethawk.herokuapp.com/api/v1/birds"))
                expect(result.httpMethod).to(equal(HTTPMethod.GET))
                expect(result.params).to(beNil())
                expect(result.headers).to(beNil())
            }
        }
        
    }
}
