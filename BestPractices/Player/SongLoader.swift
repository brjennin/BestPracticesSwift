protocol SongLoaderProtocol: class {
    func loadSongAssets(song: Song, songCompletion: (Song) -> (), imageCompletion: (Song) -> ())
}

class SongLoader: SongLoaderProtocol {
    
    var httpClient: HTTPClientProtocol! = HTTPClient()
    var songPersistence: SongPersistenceProtocol! = SongPersistence()
    
    func loadSongAssets(song: Song, songCompletion: (Song) -> (), imageCompletion: (Song) -> ()) {
        
        let songFolder = "songs/\(song.identifier)/"
        let imageFolder = "images/\(song.identifier)/"
        
        self.httpClient.downloadFile(song.url, folderPath: songFolder) { url in
            if let url = url {
                self.songPersistence.updateLocalSongUrl(song, url: url.path!)
            }
            songCompletion(song)
        }
        
        self.httpClient.downloadFile(song.albumArt, folderPath: imageFolder) { url in
            if let url = url {
                self.songPersistence.updateLocalImageUrl(song, url: url.path!)
            }
            imageCompletion(song)
        }
    }
    
}
