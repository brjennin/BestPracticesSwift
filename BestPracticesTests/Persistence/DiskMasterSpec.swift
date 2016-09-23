import Quick
import Nimble
import Fleet
@testable import BestPractices

class DiskMasterSpec: QuickSpec {
    
    override func spec() {
        
        var subject: DiskMaster!
        
        let fileManager = NSFileManager.defaultManager()
        let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let mediaDirectory = directoryURL.URLByAppendingPathComponent(MockDiskMaster.rootFolderName)
        let finalDirectory = mediaDirectory.URLByAppendingPathComponent("songs/thing/1/")
        
        beforeEach {
            subject = DiskMaster()
            subject.rootFolderName = MockDiskMaster.rootFolderName
        }
        
        describe(".wipeLocalStorage") {
            context("When there is a media folder with contents") {
                beforeEach {
                    if fileManager.fileExistsAtPath(mediaDirectory.path!) {
                        try! fileManager.removeItemAtURL(mediaDirectory)
                    }
                    try! fileManager.createDirectoryAtURL(finalDirectory, withIntermediateDirectories: true, attributes: nil)
                    
                    let fileOnePath = mediaDirectory.URLByAppendingPathComponent("file.mp3")
                    fileManager.createFileAtPath(fileOnePath.path!, contents: nil, attributes: nil)
                    let fileTwoPath = finalDirectory.URLByAppendingPathComponent("file2.mp3")
                    fileManager.createFileAtPath(fileTwoPath.path!, contents: nil, attributes: nil)
                    
                    subject.wipeLocalStorage()
                }
                
                it("removes the root media folder") {
                    expect(fileManager.fileExistsAtPath(mediaDirectory.path!)).to(beFalsy())
                }
            }
            
            context("When there is no media folder") {
                beforeEach {
                    if fileManager.fileExistsAtPath(mediaDirectory.path!) {
                        try! fileManager.removeItemAtURL(mediaDirectory)
                    }
                    
                    subject.wipeLocalStorage()
                }
                
                it("removes the root media folder") {
                    expect(fileManager.fileExistsAtPath(mediaDirectory.path!)).to(beFalsy())
                }
            }
        }
        
        describe(".mediaURLForSongWithFilename") {
            var result: NSURL!
            
            context("When the root folder doesn't exist") {
                beforeEach {
                    if fileManager.fileExistsAtPath(mediaDirectory.path!) {
                        try! fileManager.removeItemAtURL(mediaDirectory)
                    }
                    
                    result = subject.mediaURLForSongWithFilename("songs/thing/1/", filename: "file.mp3")
                }
                
                it("creates intermediate folders and returns the URL to where the file would go") {
                    expect(fileManager.fileExistsAtPath(finalDirectory.path!)).to(beTruthy())
                    expect(result).to(equal(finalDirectory.URLByAppendingPathComponent("file.mp3")))
                }
            }
            
            context("When the root folder does exist") {
                let songsDirectory = mediaDirectory.URLByAppendingPathComponent("songs/")
                
                beforeEach {
                    if fileManager.fileExistsAtPath(mediaDirectory.path!) {
                        try! fileManager.removeItemAtURL(mediaDirectory)
                    }
                    try! fileManager.createDirectoryAtURL(mediaDirectory, withIntermediateDirectories: true, attributes: nil)
                }
                
                context("When the intermediate folders exist") {
                    let filePath = finalDirectory.URLByAppendingPathComponent("file.mp3")
                    
                    beforeEach {
                        if fileManager.fileExistsAtPath(songsDirectory.path!) {
                            try! fileManager.removeItemAtURL(songsDirectory)
                        }
                        try! fileManager.createDirectoryAtURL(finalDirectory, withIntermediateDirectories: true, attributes: nil)
                    }
                    
                    context("When the file already exists") {
                        beforeEach {
                            fileManager.createFileAtPath(filePath.path!, contents: nil, attributes: nil)
                            result = subject.mediaURLForSongWithFilename("songs/thing/1/", filename: "file.mp3")
                        }
                        
                        it("creates intermediate folders and returns the URL to where the file would go") {
                            expect(fileManager.fileExistsAtPath(finalDirectory.path!)).to(beTruthy())
                            expect(result).to(equal(filePath))
                        }
                        
                        it("removes the existing file") {
                            expect(fileManager.fileExistsAtPath(filePath.path!)).to(beFalsy())
                        }
                    }
                    
                    context("When the file does not already exist") {
                        beforeEach {
                            result = subject.mediaURLForSongWithFilename("songs/thing/1/", filename: "file.mp3")
                        }
                        
                        it("creates intermediate folders and returns the URL to where the file would go") {
                            expect(fileManager.fileExistsAtPath(finalDirectory.path!)).to(beTruthy())
                            expect(result).to(equal(filePath))
                        }
                        
                        it("does not have a file in the location") {
                            expect(fileManager.fileExistsAtPath(filePath.path!)).to(beFalsy())
                        }
                    }
                }
                
                context("When the intermediate folders don't exist") {
                    beforeEach {
                        if fileManager.fileExistsAtPath(songsDirectory.path!) {
                            try! fileManager.removeItemAtURL(songsDirectory)
                        }

                        result = subject.mediaURLForSongWithFilename("songs/thing/1/", filename: "file.mp3")
                    }
                    
                    it("creates intermediate folders and returns the URL to where the file would go") {
                        expect(fileManager.fileExistsAtPath(finalDirectory.path!)).to(beTruthy())
                        expect(result).to(equal(finalDirectory.URLByAppendingPathComponent("file.mp3")))
                    }
                }
            }
        }
    }
}
