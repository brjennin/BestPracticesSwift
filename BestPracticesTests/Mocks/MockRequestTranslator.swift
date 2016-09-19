import Alamofire
@testable import BestPractices

class MockRequestTranslator: RequestTranslatorProtocol {
    
    var calledTranslate = false
    var capturedRequest: HTTPRequest?
    
    func translateRequestForAlamofire(request: HTTPRequest) -> Request {
        calledTranslate = true
        capturedRequest = request
        
        return Alamofire.request(.GET, "translatedURL")
    }
}
