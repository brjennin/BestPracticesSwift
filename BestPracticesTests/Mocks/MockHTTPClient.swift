import SwiftyJSON
@testable import BestPractices

class MockHTTPClient: HTTPClientProtocol {
    var madeJSONRequest = false
    var capturedJSONRequest: HTTPRequest?
    var capturedJSONCompletion: ((JSON?) -> ())?

    var madeDataRequest = false
    var capturedDataURL: String?
    var capturedDataCompletion: ((NSData?) -> ())?

    func makeJsonRequest(request: HTTPRequest, completion: ((JSON?) -> ())) {
        madeJSONRequest = true
        capturedJSONRequest = request
        capturedJSONCompletion = completion
    }

    func makeDataRequest(url: String, completion: ((NSData?) -> ())) {
        madeDataRequest = true
        capturedDataURL = url
        capturedDataCompletion = completion
    }
}
