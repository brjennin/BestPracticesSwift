import Foundation
@testable import BestPractices

class MockDiskMaster: DiskMasterProtocol {
    
    static let rootFolderName = "tests"
    
    var calledWipeLocalStorage = false
    
    func wipeLocalStorage() {
        calledWipeLocalStorage = true
    }
    
    var calledMediaURLForSongWithFilename = false
    var capturedFolderForMediaURL: String?
    var capturedFilenameForMediaURL: String?
    
    func mediaURLForSongWithFilename(folder: String, filename: String) -> NSURL {
        calledMediaURLForSongWithFilename = true
        capturedFolderForMediaURL = folder
        capturedFilenameForMediaURL = filename
        
        let fileManager = NSFileManager.defaultManager()
        let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let testDirectory = directoryURL.URLByAppendingPathComponent(MockDiskMaster.rootFolderName)
        
        try! fileManager.createDirectoryAtURL(testDirectory, withIntermediateDirectories: true, attributes: nil)

        return directoryURL.URLByAppendingPathComponent("\(MockDiskMaster.rootFolderName)/testfile.example")
    }
    
}
