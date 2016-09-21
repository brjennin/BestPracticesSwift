import SwiftyJSON

protocol SongServiceProtocol: class {
    func getSongs(completion: (([Song]) -> ()))
}

class SongService: SongServiceProtocol {

    var requestProvider: RequestProviderProtocol! = RequestProvider()
    var httpClient: HTTPClientProtocol! = HTTPClient()
    var songListDeserializer: SongListDeserializerProtocol! = SongListDeserializer()

    func getSongs(completion: (([Song]) -> ())) {
        let request = self.requestProvider.getSongsListRequest()
        self.httpClient.makeJsonRequest(request) { jsonObject in
            completion(self.songListDeserializer.deserialize(jsonObject))
        }
    }

}
