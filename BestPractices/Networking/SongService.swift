import SwiftyJSON

protocol SongServiceProtocol: class {
    func getSongs(completion: (([Song]) -> ()))
}

class SongService: SongServiceProtocol {
    
    var requestProvider: RequestProviderProtocol! = RequestProvider()
    var httpClient: HTTPClientProtocol! = HTTPClient()
    
    func getSongs(completion: (([Song]) -> ())) {
        let request = self.requestProvider.getSongsListRequest()
        self.httpClient.makeJsonRequest(request) { jsonObject in
            var songs = [Song]()
            
            if let json = jsonObject {
                for (_, subJson):(String, JSON) in json {
                    let song = Song(identifier: subJson["id"].intValue,
                                    name: subJson["name"].stringValue,
                                    artist: subJson["artist"].stringValue,
                                    url: subJson["url"].stringValue,
                                    albumArt: subJson["album_art"].stringValue)
                    songs.append(song)
                }
            }

            completion(songs)
        }
    }

}
