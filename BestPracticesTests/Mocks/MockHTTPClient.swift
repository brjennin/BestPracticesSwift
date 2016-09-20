import SwiftyJSON
@testable import BestPractices

class MockHTTPClient: HTTPClientProtocol {
    var madeJSONRequest = false
    var capturedJSONRequest: HTTPRequest?
    var capturedJSONCompletion: ((JSON?) -> ())?

    var madeDataRequest = false
    var capturedDataURL: String?
    var capturedDataCompletion: ((NSData?) -> ())?

    var madeDownloadRequest = false
    var capturedDownloadURL: String?
    var capturedDownloadCompletion: ((NSURL?) -> ())?
    
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
    
    func downloadFile(url: String, completion: ((NSURL?) -> ())) {
        madeDownloadRequest = true
        capturedDownloadURL = url
        capturedDownloadCompletion = completion
    }
}
