import SwiftyJSON
@testable import BestPractices

class MockHTTPClient: HTTPClientProtocol {
    var madeRequest = false
    var capturedRequest: HTTPRequest?
    var capturedCompletion: ((JSON?) -> ())?
    
    func makeJsonRequest(request: HTTPRequest, completion: ((JSON?) -> ())) {
        madeRequest = true
        capturedRequest = request
        capturedCompletion = completion
    }
}
