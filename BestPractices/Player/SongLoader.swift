protocol SongLoaderProtocol: class {
    func loadSongAssets(song: Song, songCompletion: @escaping (Song) -> (), imageCompletion: @escaping (Song) -> ())
}

class SongLoader: SongLoaderProtocol {

    var httpClient: HTTPClientProtocol! = HTTPClient()
    var soundPersistence: SoundPersistenceProtocol! = SoundPersistence()
    var diskMaster: DiskMasterProtocol! = DiskMaster()

    func loadSongAssets(song: Song, songCompletion: @escaping (Song) -> (), imageCompletion: @escaping (Song) -> ()) {
        fetchAssetAtPath(song: song, folderName: "songs", path: song.songLocalPath, downloadURL: song.url, completion: songCompletion, updateFunction: self.soundPersistence.updateLocalSongUrl)

        fetchAssetAtPath(song: song, folderName: "images", path: song.imageLocalPath, downloadURL: song.albumArt, completion: imageCompletion, updateFunction: self.soundPersistence.updateLocalImageUrl)
    }

    fileprivate func fetchAssetAtPath(song: Song, folderName: String, path: String?, downloadURL: String, completion: @escaping (Song) -> (), updateFunction: @escaping (Song, String) -> ()) {
        if path != nil && self.diskMaster.isMediaFilePresent(path: path!) {
            completion(song)
        } else {
            let folder = "\(folderName)/\(song.identifier)/"
            self.httpClient.downloadFile(url: downloadURL, folderPath: folder) { url in
                if let url = url {
                    updateFunction(song, url.path)
                }
                completion(song)
            }
        }
    }

}
