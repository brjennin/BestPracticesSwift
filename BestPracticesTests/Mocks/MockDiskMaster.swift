import Foundation
@testable import BestPractices

class MockDiskMaster: DiskMasterProtocol {

    static let rootFolderName = "tests"

    var calledWipeLocalStorage = false

    func wipeLocalStorage() {
        calledWipeLocalStorage = true
    }

    var calledMediaURLForFileWithFilename = false
    var capturedFolderForMediaURL: String?
    var capturedFilenameForMediaURL: String?

    func mediaURLForFileWithFilename(folder: String, filename: String) -> URL {
        calledMediaURLForFileWithFilename = true
        capturedFolderForMediaURL = folder
        capturedFilenameForMediaURL = filename

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
