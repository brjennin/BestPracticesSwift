protocol SoundLoaderProtocol: class {
    func loadSoundAssets(sound: Sound, soundCompletion: @escaping (Sound) -> (), imageCompletion: @escaping (Sound) -> ())
}

class SoundLoader: SoundLoaderProtocol {

    var httpClient: HTTPClientProtocol! = HTTPClient()
    var soundPersistence: SoundPersistenceProtocol! = SoundPersistence()
    var diskMaster: DiskMasterProtocol! = DiskMaster()

    func loadSoundAssets(sound: Sound, soundCompletion: @escaping (Sound) -> (), imageCompletion: @escaping (Sound) -> ()) {
        fetchAssetAtPath(sound: sound, folderName: "audio", path: sound.soundLocalPath, downloadURL: sound.url, completion: soundCompletion, updateFunction: self.soundPersistence.updateLocalSoundUrl)

        fetchAssetAtPath(sound: sound, folderName: "images", path: sound.imageLocalPath, downloadURL: sound.albumArt, completion: imageCompletion, updateFunction: self.soundPersistence.updateLocalImageUrl)
    }

    fileprivate func fetchAssetAtPath(sound: Sound, folderName: String, path: String?, downloadURL: String, completion: @escaping (Sound) -> (), updateFunction: @escaping (Sound, String) -> ()) {
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
