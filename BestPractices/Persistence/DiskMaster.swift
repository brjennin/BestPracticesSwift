import Foundation

protocol DiskMasterProtocol: class {
    func wipeLocalStorage()
    
    func mediaURLForSongWithFilename(folder: String, filename: String) -> NSURL
}

class DiskMaster: DiskMasterProtocol {
    
    var rootFolderName = "media"
    let fileManager = NSFileManager.defaultManager()
    
    func wipeLocalStorage() {
        let directoryURL = self.fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let rootMediaFolder = directoryURL.URLByAppendingPathComponent(self.rootFolderName)
        if fileManager.fileExistsAtPath(rootMediaFolder.path!) {
            _ = try? fileManager.removeItemAtURL(rootMediaFolder)
        }
    }
    
    func mediaURLForSongWithFilename(folder: String, filename: String) -> NSURL {
        let directoryURL = self.fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let directoryForFile = directoryURL.URLByAppendingPathComponent("\(self.rootFolderName)/\(folder)")
        let fileURL = directoryForFile.URLByAppendingPathComponent(filename)
        
        try! fileManager.createDirectoryAtURL(directoryForFile, withIntermediateDirectories: true, attributes: nil)
        if fileManager.fileExistsAtPath(fileURL.path!) {
            try! fileManager.removeItemAtURL(fileURL)
        }
        
        return fileURL
    }
}
