import SwiftyJSON
@testable import BestPractices

class MockHTTPClient: HTTPClientProtocol {
    var madeJSONRequest = false
    var capturedJSONRequest: HTTPRequest?
    var capturedJSONCompletion: ((JSON?, NSError?) -> ())?

    func makeJsonRequest(request: HTTPRequest, completion: @escaping ((JSON?, NSError?) -> ())) {
        madeJSONRequest = true
        capturedJSONRequest = request
        capturedJSONCompletion = completion
    }

    var downloadCallCount = 0
    var downloadUrls = [String]()
    var downloadFolders = [String]()
    var downloadCompletions: [((URL?) -> ())] = []

    func downloadFile(url: String, folderPath: String, completion: @escaping ((URL?) -> ())) {
        downloadCallCount += 1
        downloadUrls.append(url)
        downloadFolders.append(folderPath)
        downloadCompletions.append(completion)
    }
}
