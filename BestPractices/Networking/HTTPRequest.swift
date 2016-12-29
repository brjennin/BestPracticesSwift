import Alamofire

struct HTTPRequest {
    fileprivate(set) var urlString: String
    fileprivate(set) var httpMethod: HTTPMethod
    fileprivate(set) var params: [String: AnyObject]?
    fileprivate(set) var headers: [String: String]?
    
    init(urlString: String, httpMethod: HTTPMethod, params: [String: AnyObject]?, headers: [String: String]?) {
        self.urlString = urlString
        self.httpMethod = httpMethod
        self.params = params
        self.headers = headers
    }
}
