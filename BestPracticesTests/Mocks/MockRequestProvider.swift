@testable import BestPractices

class MockRequestProvider: RequestProviderProtocol {
    var calledGetSongsListRequest = false
    
    func getSongsListRequest() -> HTTPRequest {
        calledGetSongsListRequest = true
        return HTTPRequest(urlString: "getSongsList", httpMethod: HTTPMethod.GET, params: nil, headers: nil)
    }
}
