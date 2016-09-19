enum HTTPMethod {
    case GET
}

struct HTTPRequest {
    private(set) var urlString: String
    private(set) var httpMethod: HTTPMethod
    private(set) var params: [String: AnyObject]?
    private(set) var headers: [String: String]?
    
    init(urlString: String, httpMethod: HTTPMethod, params: [String: AnyObject]?, headers: [String: String]?) {
        self.urlString = urlString
        self.httpMethod = httpMethod
        self.params = params
        self.headers = headers
    }
}
