protocol SongLoaderProtocol: class {
    func loadSongAssets(song: Song, songCompletion: (Song) -> (), imageCompletion: (Song) -> ())
}

class SongLoader: SongLoaderProtocol {

    var httpClient: HTTPClientProtocol! = HTTPClient()
    var songPersistence: SongPersistenceProtocol! = SongPersistence()
    var diskMaster: DiskMasterProtocol! = DiskMaster()

    func loadSongAssets(song: Song, songCompletion: (Song) -> (), imageCompletion: (Song) -> ()) {
        fetchAssetAtPath(song, folderName: "songs", path: song.songLocalPath, downloadURL: song.url, completion: songCompletion, updateFunction: self.songPersistence.updateLocalSongUrl)

        fetchAssetAtPath(song, folderName: "images", path: song.imageLocalPath, downloadURL: song.albumArt, completion: imageCompletion, updateFunction: self.songPersistence.updateLocalImageUrl)
    }

    private func fetchAssetAtPath(song: Song, folderName: String, path: String?, downloadURL: String, completion: (Song) -> (), updateFunction: (Song, String) -> ()) {
        if path != nil && self.diskMaster.isMediaFilePresent(path!) {
            completion(song)
        } else {
            let folder = "\(folderName)/\(song.identifier)/"
            self.httpClient.downloadFile(downloadURL, folderPath: folder) { url in
                if let url = url {
                    updateFunction(song, url.path!)
                }
                completion(song)
            }
        }
    }

}
