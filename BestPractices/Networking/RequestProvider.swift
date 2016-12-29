import Alamofire

protocol RequestProviderProtocol: class {
    func getSoundsListRequest() -> HTTPRequest
}

class RequestProvider: RequestProviderProtocol {
  
    func getSoundsListRequest() -> HTTPRequest {
        return HTTPRequest(urlString: "https://yachty.herokuapp.com/api/v1/songs", httpMethod: HTTPMethod.get, params: nil, headers: nil)
    }
    
}
