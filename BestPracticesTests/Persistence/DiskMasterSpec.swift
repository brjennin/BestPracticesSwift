import Quick
import Nimble
@testable import BestPractices

class DiskMasterSpec: QuickSpec {

    override func spec() {

        var subject: DiskMaster!

        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let mediaDirectory = directoryURL.appendingPathComponent(MockDiskMaster.rootFolderName)
        let finalDirectory = mediaDirectory.appendingPathComponent("sounds/thing/1/")

        beforeEach {
            subject = DiskMaster()
            subject.rootFolderName = MockDiskMaster.rootFolderName
        }

        describe(".wipeLocalStorage") {
            context("When there is a media folder with contents") {
                beforeEach {
                    if fileManager.fileExists(atPath: mediaDirectory.path) {
                        try! fileManager.removeItem(at: mediaDirectory)
                    }
                    try! fileManager.createDirectory(at: finalDirectory, withIntermediateDirectories: true, attributes: nil)

                    let fileOnePath = mediaDirectory.appendingPathComponent("file.mp3")
                    fileManager.createFile(atPath: fileOnePath.path, contents: nil, attributes: nil)
                    let fileTwoPath = finalDirectory.appendingPathComponent("file2.mp3")
                    fileManager.createFile(atPath: fileTwoPath.path, contents: nil, attributes: nil)

                    subject.wipeLocalStorage()
                }

                it("removes the root media folder") {
                    expect(fileManager.fileExists(atPath: mediaDirectory.path)).to(beFalsy())
                }
            }

            context("When there is no media folder") {
                beforeEach {
                    if fileManager.fileExists(atPath: mediaDirectory.path) {
                        try! fileManager.removeItem(at: mediaDirectory)
                    }

                    subject.wipeLocalStorage()
                }

                it("removes the root media folder") {
                    expect(fileManager.fileExists(atPath: mediaDirectory.path)).to(beFalsy())
                }
            }
        }

        describe(".destructiveMediaURLForFileWithFilename") {
            var result: URL!

            context("When the root folder doesn't exist") {
                beforeEach {
                    if fileManager.fileExists(atPath: mediaDirectory.path) {
                        try! fileManager.removeItem(at: mediaDirectory)
                    }

                    result = subject.destructiveMediaURLForFileWithFilename(folder: "sounds/thing/1/", filename: "file.mp3")
                }

                it("creates intermediate folders and returns the URL to where the file would go") {
                    expect(fileManager.fileExists(atPath: finalDirectory.path)).to(beTruthy())
                    expect(result).to(equal(finalDirectory.appendingPathComponent("file.mp3")))
                }
            }

            context("When the root folder does exist") {
                let soundsDirectory = mediaDirectory.appendingPathComponent("sounds/")

                beforeEach {
                    if fileManager.fileExists(atPath: mediaDirectory.path) {
                        try! fileManager.removeItem(at: mediaDirectory)
                    }
                    try! fileManager.createDirectory(at: mediaDirectory, withIntermediateDirectories: true, attributes: nil)
                }

                context("When the intermediate folders exist") {
                    let filePath = finalDirectory.appendingPathComponent("file.mp3")

                    beforeEach {
                        if fileManager.fileExists(atPath: soundsDirectory.path) {
                            try! fileManager.removeItem(at: soundsDirectory)
                        }
                        try! fileManager.createDirectory(at: finalDirectory, withIntermediateDirectories: true, attributes: nil)
                    }

                    context("When the file already exists") {
                        beforeEach {
                            fileManager.createFile(atPath: filePath.path, contents: nil, attributes: nil)
                            result = subject.destructiveMediaURLForFileWithFilename(folder: "sounds/thing/1/", filename: "file.mp3")
                        }

                        it("creates intermediate folders and returns the URL to where the file would go") {
                            expect(fileManager.fileExists(atPath: finalDirectory.path)).to(beTruthy())
                            expect(result).to(equal(filePath))
                        }

                        it("removes the existing file") {
                            expect(fileManager.fileExists(atPath: filePath.path)).to(beFalsy())
                        }
                    }

                    context("When the file does not already exist") {
                        beforeEach {
                            result = subject.destructiveMediaURLForFileWithFilename(folder: "sounds/thing/1/", filename: "file.mp3")
                        }

                        it("creates intermediate folders and returns the URL to where the file would go") {
                            expect(fileManager.fileExists(atPath: finalDirectory.path)).to(beTruthy())
                            expect(result).to(equal(filePath))
                        }

                        it("does not have a file in the location") {
                            expect(fileManager.fileExists(atPath: filePath.path)).to(beFalsy())
                        }
                    }
                }

                context("When the intermediate folders don't exist") {
                    beforeEach {
                        if fileManager.fileExists(atPath: soundsDirectory.path) {
                            try! fileManager.removeItem(at: soundsDirectory)
                        }

                        result = subject.destructiveMediaURLForFileWithFilename(folder: "sounds/thing/1/", filename: "file.mp3")
                    }

                    it("creates intermediate folders and returns the URL to where the file would go") {
                        expect(fileManager.fileExists(atPath: finalDirectory.path)).to(beTruthy())
                        expect(result).to(equal(finalDirectory.appendingPathComponent("file.mp3")))
                    }
                }
            }
        }

        describe(".mediaURLForFileWithFilename") {
            var result: URL!
            let filePath = finalDirectory.appendingPathComponent("file.mp3")

            beforeEach {
                result = subject.mediaURLForFileWithFilename(filepath: "sounds/thing/1/file.mp3")
            }

            it("returns the url for the item on disk") {
                expect(result).to(equal(filePath))
            }
        }

        describe(".isMediaFilePresent") {
            let filePath = finalDirectory.appendingPathComponent("file.mp3")
            var result: Bool!

            context("When file is present") {                
                beforeEach {
                    if fileManager.fileExists(atPath: filePath.path) {
                        try! fileManager.removeItem(at: filePath)
                    }
                    fileManager.createFile(atPath: filePath.path, contents: nil, attributes: nil)
                    result = subject.isMediaFilePresent(path: "sounds/thing/1/file.mp3")
                }

                it("returns true") {
                    expect(result).to(beTruthy())
                }
            }

            context("When file is not present") {
                beforeEach {
                    if fileManager.fileExists(atPath: filePath.path) {
                        try! fileManager.removeItem(at: filePath)
                    }
                    result = subject.isMediaFilePresent(path: "sounds/thing/1/file.mp3")
                }

                it("returns false") {
                    expect(result).to(beFalsy())
                }
            }
        }
    }
}
