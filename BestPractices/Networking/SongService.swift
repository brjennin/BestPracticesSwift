import SwiftyJSON

protocol SongServiceProtocol: class {
    func getSongs(completion: (([Song]?, NSError?) -> ()))
}

class SongService: SongServiceProtocol {

    var requestProvider: RequestProviderProtocol! = RequestProvider()
    var httpClient: HTTPClientProtocol! = HTTPClient()
    var songListDeserializer: SongListDeserializerProtocol! = SongListDeserializer()

    func getSongs(completion: (([Song]?, NSError?) -> ())) {
        let request = self.requestProvider.getSongsListRequest()
        self.httpClient.makeJsonRequest(request) { jsonObject, error in
            completion(self.songListDeserializer.deserialize(jsonObject), error)
        }
    }

}
