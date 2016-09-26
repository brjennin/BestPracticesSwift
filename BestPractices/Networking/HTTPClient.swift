import SwiftyJSON
import Alamofire
import Foundation

protocol HTTPClientProtocol: class {
    func makeJsonRequest(request: HTTPRequest, completion: ((JSON?, NSError?) -> ()))

    func downloadFile(url: String, folderPath: String, completion: ((NSURL?) -> ()))
}

class HTTPClient: HTTPClientProtocol {

    var requestTranslator: RequestTranslatorProtocol! = RequestTranslator()
    var diskMaster: DiskMasterProtocol! = DiskMaster()
    var activityIndicator: ActivityIndicatorProtocol! = ActivityIndicator()

    func makeJsonRequest(request: HTTPRequest, completion: ((JSON?, NSError?) -> ())) {
        self.activityIndicator.start()

        let alamofireRequest = self.requestTranslator.translateRequestForAlamofire(request)
        alamofireRequest.validate().responseJSON(completionHandler: { [weak self] response in
            var json: JSON?
            self?.activityIndicator.stop()

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

    func downloadFile(url: String, folderPath: String, completion: ((NSURL?) -> ())) {
        var destinationURL: NSURL?
        self.activityIndicator.start()

        Alamofire.download(.GET, url) {[weak self] (temporaryURL, response) in
            destinationURL = self?.diskMaster.mediaURLForSongWithFilename(folderPath, filename: response.suggestedFilename!)

            return destinationURL!
        }.validate().response {[weak self] _, _, _, error in
            var url: NSURL?
            self?.activityIndicator.stop()

            if error == nil {
                url = destinationURL
            }
            completion(url)
        }
    }
}
