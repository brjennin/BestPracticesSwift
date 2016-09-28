import Alamofire
@testable import BestPractices

class MockRequestProvider: RequestProviderProtocol {
    var calledGetSongsListRequest = false
    
    func getSongsListRequest() -> HTTPRequest {
        calledGetSongsListRequest = true
        return HTTPRequest(urlString: "getSongsList", httpMethod: HTTPMethod.get, params: nil, headers: nil)
    }
}
