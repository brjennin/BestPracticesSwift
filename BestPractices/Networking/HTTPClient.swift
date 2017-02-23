import SwiftyJSON
import Alamofire
import Foundation

protocol HTTPClientProtocol: class {
    func makeJsonRequest(request: HTTPRequest, completion: @escaping ((JSON?, NSError?) -> ()))

    func downloadFile(url: String, folderPath: String, completion: @escaping ((URL?) -> ()))
}

class HTTPClient: HTTPClientProtocol {

    var requestTranslator: RequestTranslatorProtocol! = RequestTranslator()
    var diskMaster: DiskMasterProtocol! = DiskMaster()
    var activityIndicator: ActivityIndicatorProtocol! = ActivityIndicator()

    func makeJsonRequest(request: HTTPRequest, completion: @escaping ((JSON?, NSError?) -> ())) {
        self.activityIndicator.start()

        let alamofireRequest = self.requestTranslator.translateRequestForAlamofire(request: request)
        alamofireRequest.validate().responseJSON { [weak self] response in
            var json: JSON?
            self?.activityIndicator.stop()
            
            switch response.result {
            case .success:
                if let jsonResult = response.data {
                    json = JSON(data: jsonResult)
                }
            case .failure(_):
                break
            }
            
            completion(json, response.result.error as NSError!)
        }
    }

    func downloadFile(url: String, folderPath: String, completion: @escaping ((URL?) -> ())) {
        self.activityIndicator.start()
        
        let destination: DownloadRequest.DownloadFileDestination = { [weak self] _, response in
            let destinationURL = self!.diskMaster.destructiveMediaURLForFileWithFilename(folder: folderPath, filename: response.suggestedFilename!)
            
            return (destinationURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(url, to: destination).validate().response { [weak self] response in
            self?.activityIndicator.stop()
            if response.error == nil {
                completion(response.destinationURL)
            } else {
                completion(nil)
            }
        }
    }
}
