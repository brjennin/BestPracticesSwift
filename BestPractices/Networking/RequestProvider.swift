import Alamofire

protocol RequestProviderProtocol: class {
    func getSongsListRequest() -> HTTPRequest
}

class RequestProvider: RequestProviderProtocol {
  
    func getSongsListRequest() -> HTTPRequest {
        return HTTPRequest(urlString: "https://yachty.herokuapp.com/api/v1/songs", httpMethod: HTTPMethod.get, params: nil, headers: nil)
    }
    
}
