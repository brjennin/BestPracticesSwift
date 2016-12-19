import Alamofire
@testable import BestPractices

class MockRequestTranslator: RequestTranslatorProtocol {
    
    var calledTranslate = false
    var capturedRequest: HTTPRequest?
    var returnValueForRequestTranslation: String?
    
    func translateRequestForAlamofire(request: HTTPRequest) -> DataRequest {
        calledTranslate = true
        capturedRequest = request
        
        return Alamofire.request(returnValueForRequestTranslation!)
    }
}
