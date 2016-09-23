import Quick
import Nimble
import Fleet
@testable import BestPractices

class SongLoaderSpec: QuickSpec {
    override func spec() {
        
        var subject: SongLoader!
        var httpClient: MockHTTPClient!
        var songPersistence: MockSongPersistence!
        
        beforeEach {
            subject = SongLoader()
            
            httpClient = MockHTTPClient()
            subject.httpClient = httpClient
            
            songPersistence = MockSongPersistence()
            subject.songPersistence = songPersistence
        }
        
        describe(".loadSongAssets") {
            var song: Song!
            
            let bundle = NSBundle(forClass: self.dynamicType)
            
            var capturedSongFromSongCompletion: Song?
            var calledSongCompletion = false
            var capturedSongFromImageCompletion: Song?
            var calledImageCompletion = false
            
            beforeEach {
                song = Song(value: ["identifier": 384, "url": "songUrl", "albumArt": "imageUrl"])
                subject.loadSongAssets(song, songCompletion: { capturedSong in
                    calledSongCompletion = true
                    capturedSongFromSongCompletion = capturedSong
                }, imageCompletion: { capturedSong in
                    calledImageCompletion = true
                    capturedSongFromImageCompletion = capturedSong
                })
            }
            
            it("downloads 2 files") {
                expect(httpClient.downloadCallCount).to(equal(2))
            }
            
            it("calls the http client for the song request") {
                expect(httpClient.downloadUrls[0]).to(equal("songUrl"))
                expect(httpClient.downloadFolders[0]).to(equal("songs/384/"))
            }
            
            it("calls the http client for the image request") {
                expect(httpClient.downloadUrls[1]).to(equal("imageUrl"))
                expect(httpClient.downloadFolders[1]).to(equal("images/384/"))
            }
            
            describe("When the song completion resolves") {
                context("When there is a URL") {
                    let path = bundle.pathForResource("maneater", ofType: "mp3")!
                    let sampleFileURL = NSURL(fileURLWithPath: path)
                    
                    beforeEach {
                        httpClient.downloadCompletions[0](sampleFileURL)
                    }
                    
                    it("calls the completion callback with a local url") {
                        expect(calledSongCompletion).to(beTruthy())
                        expect(capturedSongFromSongCompletion!.identifier).to(equal(384))
                    }
                    
                    it("persists the new song url") {
                        expect(songPersistence.calledUpdateSongUrl).to(beTruthy())
                        expect(songPersistence.capturedUpdateSongUrlSong!.identifier).to(equal(384))
                        expect(songPersistence.capturedUpdateSongUrlUrl!).to(equal(sampleFileURL.path!))
                    }
                }
                
                context("When there is no URL") {
                    beforeEach {
                        httpClient.downloadCompletions[0](nil)
                    }
                    
                    it("calls the completion callback with a nil local url") {
                        expect(calledSongCompletion).to(beTruthy())
                        expect(capturedSongFromSongCompletion!.identifier).to(equal(384))
                    }
                    
                    it("does not persist the new song url") {
                        expect(songPersistence.calledUpdateSongUrl).to(beFalsy())
                    }
                }
            }
            
            describe("When the image completion resolves") {
                context("When there is a URL") {
                    let path = bundle.pathForResource("hall_and_oates_cover", ofType: "jpeg")!
                    let sampleFileURL = NSURL(fileURLWithPath: path)
                    
                    beforeEach {
                        httpClient.downloadCompletions[1](sampleFileURL)
                    }
                    
                    it("calls the completion callback with a local url") {
                        expect(calledImageCompletion).to(beTruthy())
                        expect(capturedSongFromImageCompletion!.identifier).to(equal(384))
                    }
                    
                    it("persists the new song url") {
                        expect(songPersistence.calledUpdateImageUrl).to(beTruthy())
                        expect(songPersistence.capturedUpdateImageUrlSong!.identifier).to(equal(384))
                        expect(songPersistence.capturedUpdateImageUrlUrl!).to(equal(sampleFileURL.path!))
                    }
                }
                
                context("When there is no URL") {
                    beforeEach {
                        httpClient.downloadCompletions[1](nil)
                    }
                    
                    it("calls the completion callback with a nil local url") {
                        expect(calledImageCompletion).to(beTruthy())
                        expect(capturedSongFromImageCompletion!.identifier).to(equal(384))
                    }
                    
                    it("does not persist the new song url") {
                        expect(songPersistence.calledUpdateImageUrl).to(beFalsy())
                    }
                }
            }
        }
        
    }
}
