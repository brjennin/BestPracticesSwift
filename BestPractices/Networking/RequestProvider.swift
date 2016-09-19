protocol RequestProviderProtocol: class {
    func getSongsListRequest() -> HTTPRequest
}

class RequestProvider: RequestProviderProtocol {
  
    func getSongsListRequest() -> HTTPRequest {
        return HTTPRequest(urlString: "https://pockethawk.herokuapp.com/api/v1/birds", httpMethod: HTTPMethod.GET, params: nil, headers: nil)
    }
    
}
