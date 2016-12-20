protocol SongLoaderProtocol: class {
    func loadSoundAssets(sound: Song, soundCompletion: @escaping (Song) -> (), imageCompletion: @escaping (Song) -> ())
}

class SongLoader: SongLoaderProtocol {

    var httpClient: HTTPClientProtocol! = HTTPClient()
    var soundPersistence: SoundPersistenceProtocol! = SoundPersistence()
    var diskMaster: DiskMasterProtocol! = DiskMaster()

    func loadSoundAssets(sound: Song, soundCompletion: @escaping (Song) -> (), imageCompletion: @escaping (Song) -> ()) {
        fetchAssetAtPath(sound: sound, folderName: "audio", path: sound.songLocalPath, downloadURL: sound.url, completion: soundCompletion, updateFunction: self.soundPersistence.updateLocalSoundUrl)

        fetchAssetAtPath(sound: sound, folderName: "images", path: sound.imageLocalPath, downloadURL: sound.albumArt, completion: imageCompletion, updateFunction: self.soundPersistence.updateLocalImageUrl)
    }

    fileprivate func fetchAssetAtPath(sound: Song, folderName: String, path: String?, downloadURL: String, completion: @escaping (Song) -> (), updateFunction: @escaping (Song, String) -> ()) {
        if path != nil && self.diskMaster.isMediaFilePresent(path: path!) {
            completion(sound)
        } else {
            let folder = "\(folderName)/\(sound.identifier)/"
            self.httpClient.downloadFile(url: downloadURL, folderPath: folder) { url in
                if let url = url {
                    updateFunction(sound, url.path)
                }
                completion(sound)
            }
        }
    }

}
