import Foundation

protocol DiskMasterProtocol: class {
    func wipeLocalStorage()

    func mediaURLForFileWithFilename(folder: String, filename: String) -> URL

    func isMediaFilePresent(path: String) -> Bool
}

class DiskMaster: DiskMasterProtocol {

    var rootFolderName = "media"
    let fileManager = FileManager.default

    func wipeLocalStorage() {
        let directoryURL = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let rootMediaFolder = directoryURL.appendingPathComponent(self.rootFolderName)
        if fileManager.fileExists(atPath: rootMediaFolder.path) {
            _ = try? fileManager.removeItem(at: rootMediaFolder)
        }
    }

    func mediaURLForFileWithFilename(folder: String, filename: String) -> URL {
        let directoryURL = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let directoryForFile = directoryURL.appendingPathComponent("\(self.rootFolderName)/\(folder)")
        let fileURL = directoryForFile.appendingPathComponent(filename)

        try! fileManager.createDirectory(at: directoryForFile, withIntermediateDirectories: true, attributes: nil)
        if fileManager.fileExists(atPath: fileURL.path) {
            try! fileManager.removeItem(at: fileURL)
        }

        return fileURL
    }

    func isMediaFilePresent(path: String) -> Bool {
        let directoryURL = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = directoryURL.appendingPathComponent("\(self.rootFolderName)/\(path)")
        return fileManager.fileExists(atPath: fileURL.path)
    }
}
