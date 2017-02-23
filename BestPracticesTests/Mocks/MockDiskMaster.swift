import Foundation
@testable import BestPractices

class MockDiskMaster: DiskMasterProtocol {

    static let rootFolderName = "tests"

    var calledWipeLocalStorage = false

    func wipeLocalStorage() {
        calledWipeLocalStorage = true
    }

    var calledDestructiveMediaURLForFileWithFilename = false
    var capturedFolderForDestructiveMediaURL: String?
    var capturedFilenameForDestructiveMediaURL: String?

    func destructiveMediaURLForFileWithFilename(folder: String, filename: String) -> URL {
        calledDestructiveMediaURLForFileWithFilename = true
        capturedFolderForDestructiveMediaURL = folder
        capturedFilenameForDestructiveMediaURL = filename

        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let testDirectory = directoryURL.appendingPathComponent(MockDiskMaster.rootFolderName)

        try! fileManager.createDirectory(at: testDirectory, withIntermediateDirectories: true, attributes: nil)

        return directoryURL.appendingPathComponent("\(MockDiskMaster.rootFolderName)/testfile.example")
    }

    var calledIsMediaFilePresent = false
    var capturedPathForMediaFilePresent: String?
    var returnValueForIsMediaFilePresent: Bool!

    func isMediaFilePresent(path: String) -> Bool {
        calledIsMediaFilePresent = true
        capturedPathForMediaFilePresent = path
        return returnValueForIsMediaFilePresent
    }

}
