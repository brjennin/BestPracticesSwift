import Alamofire

protocol RequestTranslatorProtocol: class {
    func translateRequestForAlamofire(request: HTTPRequest) -> Request
}

class RequestTranslator: RequestTranslatorProtocol {
    
    func translateRequestForAlamofire(request: HTTPRequest) -> Request {
        return Alamofire.request(.GET, request.urlString, parameters: request.params, headers: request.headers)
    }
    
}
