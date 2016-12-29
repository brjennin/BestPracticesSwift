import Alamofire

protocol RequestTranslatorProtocol: class {
    func translateRequestForAlamofire(request: HTTPRequest) -> DataRequest
}

class RequestTranslator: RequestTranslatorProtocol {
    
    func translateRequestForAlamofire(request: HTTPRequest) -> DataRequest {
        return Alamofire.request(request.urlString, method: .get, parameters: request.params, encoding: URLEncoding.default, headers: request.headers)
    }
    
}
