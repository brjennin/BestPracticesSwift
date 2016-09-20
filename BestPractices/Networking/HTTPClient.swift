import SwiftyJSON
import Alamofire
import Foundation

protocol HTTPClientProtocol: class {
    func makeJsonRequest(request: HTTPRequest, completion: ((JSON?) -> ()))
    
    func makeDataRequest(url: String, completion: ((NSData?) -> ()))
    
    func downloadFile(url: String, completion: ((NSURL?) -> ()))
}

class HTTPClient: HTTPClientProtocol {
    
    var requestTranslator: RequestTranslatorProtocol! = RequestTranslator()
    
    func makeJsonRequest(request: HTTPRequest, completion: ((JSON?) -> ())) {
        let alamofireRequest = self.requestTranslator.translateRequestForAlamofire(request)
        alamofireRequest.validate().responseJSON(completionHandler: { response in
            var json: JSON?
            
            switch response.result {
            case .Success:
                if let jsonResult = response.data {
                    json = JSON(data: jsonResult)
                }
            case .Failure(_):
                break
            }
            
            completion(json)
        })
    }
    
    func makeDataRequest(url: String, completion: ((NSData?) -> ())) {
        Alamofire.request(.GET, url).validate().responseData(completionHandler: { response in
            var data: NSData?
            
            switch response.result {
            case .Success:
                data = response.data
            case .Failure(_):
                break
            }
            
            completion(data)
        })
    }
    
    func downloadFile(url: String, completion: ((NSURL?) -> ())) {
        var destinationURL: NSURL?
        
        Alamofire.download(.GET, url) { temporaryURL, response in
            let fileManager = NSFileManager.defaultManager()
            let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            let pathComponent = response.suggestedFilename
            let finalURL = directoryURL.URLByAppendingPathComponent(pathComponent!)
            
            if fileManager.fileExistsAtPath(finalURL.path!) {
                _ = try? fileManager.removeItemAtURL(finalURL)
            }
            
            destinationURL = finalURL
            
            return finalURL
        }.validate().response { _, _, _, error in
            var url: NSURL?
            if error == nil {
                url = destinationURL
            }
            completion(url)
        }
    }
}
