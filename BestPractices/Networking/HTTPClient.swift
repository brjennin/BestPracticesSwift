import SwiftyJSON
import Alamofire
import Foundation

protocol HTTPClientProtocol: class {
    func makeJsonRequest(request: HTTPRequest, completion: ((JSON?, NSError?) -> ()))

    func makeDataRequest(url: String, completion: ((NSData?) -> ()))

    func downloadFile(url: String, folderPath: String, completion: ((NSURL?) -> ()))
}

class HTTPClient: HTTPClientProtocol {

    var requestTranslator: RequestTranslatorProtocol! = RequestTranslator()
    var diskMaster: DiskMasterProtocol! = DiskMaster()

    func makeJsonRequest(request: HTTPRequest, completion: ((JSON?, NSError?) -> ())) {
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

            completion(json, response.result.error)
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

    func downloadFile(url: String, folderPath: String, completion: ((NSURL?) -> ())) {
        var destinationURL: NSURL?

        Alamofire.download(.GET, url) { temporaryURL, response in
            destinationURL = self.diskMaster.mediaURLForSongWithFilename(folderPath, filename: response.suggestedFilename!)

            return destinationURL!
        }.validate().response { _, _, _, error in
            var url: NSURL?
            if error == nil {
                url = destinationURL
            }
            completion(url)
        }
    }
}
