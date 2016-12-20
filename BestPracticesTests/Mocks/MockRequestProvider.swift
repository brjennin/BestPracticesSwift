import Alamofire
@testable import BestPractices

class MockRequestProvider: RequestProviderProtocol {
    var calledGetSoundsListRequest = false
    
    func getSoundsListRequest() -> HTTPRequest {
        calledGetSoundsListRequest = true
        return HTTPRequest(urlString: "getSoundsList", httpMethod: HTTPMethod.get, params: nil, headers: nil)
    }
}
