import SwiftyJSON
import Alamofire

protocol HTTPClientProtocol: class {
    func makeJsonRequest(request: HTTPRequest, completion: ((JSON?) -> ()))
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
    
}
