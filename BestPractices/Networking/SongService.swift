import SwiftyJSON

protocol SongServiceProtocol: class {
    func getSongs(completion: @escaping (([Song]?, NSError?) -> ()))
}

class SongService: SongServiceProtocol {

    var requestProvider: RequestProviderProtocol! = RequestProvider()
    var httpClient: HTTPClientProtocol! = HTTPClient()
    var songListDeserializer: SongListDeserializerProtocol! = SongListDeserializer()

    func getSongs(completion: @escaping (([Song]?, NSError?) -> ())) {
        let request = self.requestProvider.getSongsListRequest()
        self.httpClient.makeJsonRequest(request: request) { [weak self] jsonObject, error in
            completion(self?.songListDeserializer.deserialize(json: jsonObject), error)
        }
    }

}
