import SwiftyJSON
@testable import BestPractices

class MockHTTPClient: HTTPClientProtocol {
    var madeJSONRequest = false
    var capturedJSONRequest: HTTPRequest?
    var capturedJSONCompletion: ((JSON?) -> ())?

    func makeJsonRequest(request: HTTPRequest, completion: ((JSON?) -> ())) {
        madeJSONRequest = true
        capturedJSONRequest = request
        capturedJSONCompletion = completion
    }

    var madeDataRequest = false
    var capturedDataURL: String?
    var capturedDataCompletion: ((NSData?) -> ())?
    
    func makeDataRequest(url: String, completion: ((NSData?) -> ())) {
        madeDataRequest = true
        capturedDataURL = url
        capturedDataCompletion = completion
    }
    
    var madeDownloadRequest = false
    var capturedDownloadURL: String?
    var capturedFolderPath: String?
    var capturedDownloadCompletion: ((NSURL?) -> ())?
    
    func downloadFile(url: String, folderPath: String, completion: ((NSURL?) -> ())) {
        madeDownloadRequest = true
        capturedDownloadURL = url
        capturedFolderPath = folderPath
        capturedDownloadCompletion = completion
    }
}
