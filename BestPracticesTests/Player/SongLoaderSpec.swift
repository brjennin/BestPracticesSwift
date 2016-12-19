import Quick
import Nimble
@testable import BestPractices

class SongLoaderSpec: QuickSpec {
    override func spec() {

        var subject: SongLoader!
        var httpClient: MockHTTPClient!
        var soundPersistence: MockSoundPersistence!
        var diskMaster: MockDiskMaster!

        beforeEach {
            subject = SongLoader()

            httpClient = MockHTTPClient()
            subject.httpClient = httpClient

            soundPersistence = MockSoundPersistence()
            subject.soundPersistence = soundPersistence

            diskMaster = MockDiskMaster()
            subject.diskMaster = diskMaster
        }

        describe(".loadSongAssets") {
            var song: Song!

            let bundle = Bundle(for: type(of: self))

            var capturedSongFromSongCompletion: Song?
            var calledSongCompletion = false
            var capturedSongFromImageCompletion: Song?
            var calledImageCompletion = false

            let songCompletion: ((Song) -> ()) = { capturedSong in
                calledSongCompletion = true
                capturedSongFromSongCompletion = capturedSong
            }
            let imageCompletion: ((Song) -> ()) = { capturedSong in
                calledImageCompletion = true
                capturedSongFromImageCompletion = capturedSong
            }

            sharedExamples("downloading a song", closure: {
                it("calls the http client for the song request") {
                    expect(httpClient.downloadUrls.first!).to(equal("songUrl"))
                    expect(httpClient.downloadFolders.first!).to(equal("songs/384/"))
                }

                describe("When the song completion resolves") {
                    context("When there is a URL") {
                        let path = bundle.path(forResource: "maneater", ofType: "mp3")!
                        let sampleFileURL = URL(fileURLWithPath: path)

                        beforeEach {
                            httpClient.downloadCompletions.first!(sampleFileURL)
                        }

                        it("calls the completion callback with a local url") {
                            expect(calledSongCompletion).to(beTruthy())
                            expect(capturedSongFromSongCompletion!.identifier).to(equal(384))
                        }

                        it("persists the new song url") {
                            expect(soundPersistence.calledUpdateSongUrl).to(beTruthy())
                            expect(soundPersistence.capturedUpdateSongUrlSong!.identifier).to(equal(384))
                            expect(soundPersistence.capturedUpdateSongUrlUrl!).to(equal(sampleFileURL.path))
                        }
                    }

                    context("When there is no URL") {
                        beforeEach {
                            httpClient.downloadCompletions.first!(nil)
                        }

                        it("calls the completion callback with a nil local url") {
                            expect(calledSongCompletion).to(beTruthy())
                            expect(capturedSongFromSongCompletion!.identifier).to(equal(384))
                        }

                        it("does not persist the new song url") {
                            expect(soundPersistence.calledUpdateSongUrl).to(beFalsy())
                        }
                    }
                }
            })

            sharedExamples("downloading an image", closure: {
                it("calls the http client for the image request") {
                    expect(httpClient.downloadUrls.last!).to(equal("imageUrl"))
                    expect(httpClient.downloadFolders.last!).to(equal("images/384/"))
                }

                describe("When the image completion resolves") {
                    context("When there is a URL") {
                        let path = bundle.path(forResource: "hall_and_oates_cover", ofType: "jpeg")!
                        let sampleFileURL = URL(fileURLWithPath: path)

                        beforeEach {
                            httpClient.downloadCompletions.last!(sampleFileURL)
                        }

                        it("calls the completion callback with a local url") {
                            expect(calledImageCompletion).to(beTruthy())
                            expect(capturedSongFromImageCompletion!.identifier).to(equal(384))
                        }

                        it("persists the new song url") {
                            expect(soundPersistence.calledUpdateImageUrl).to(beTruthy())
                            expect(soundPersistence.capturedUpdateImageUrlSong!.identifier).to(equal(384))
                            expect(soundPersistence.capturedUpdateImageUrlUrl!).to(equal(sampleFileURL.path))
                        }
                    }

                    context("When there is no URL") {
                        beforeEach {
                            httpClient.downloadCompletions.last!(nil)
                        }

                        it("calls the completion callback with a nil local url") {
                            expect(calledImageCompletion).to(beTruthy())
                            expect(capturedSongFromImageCompletion!.identifier).to(equal(384))
                        }

                        it("does not persist the new image url") {
                            expect(soundPersistence.calledUpdateImageUrl).to(beFalsy())
                        }
                    }
                }
            })

            sharedExamples("not attempting to download an image", closure: {
                it("does not call the http client for the image request") {
                    expect(httpClient.downloadUrls).toNot(contain("imageUrl"))
                }

                it("calls the completion callback with the existing url") {
                    expect(calledImageCompletion).to(beTruthy())
                    expect(capturedSongFromImageCompletion!.identifier).to(equal(384))
                    expect(capturedSongFromImageCompletion!.imageLocalPath).to(equal("existingImage"))
                }

                it("does not persist the image url") {
                    expect(soundPersistence.calledUpdateImageUrl).to(beFalsy())
                }
            })

            sharedExamples("not attempting to download a song", closure: {
                it("does not call the http client for the song request") {
                    expect(httpClient.downloadUrls).toNot(contain("songUrl"))
                }

                it("calls the completion callback with the existing url") {
                    expect(calledSongCompletion).to(beTruthy())
                    expect(capturedSongFromSongCompletion!.identifier).to(equal(384))
                    expect(capturedSongFromSongCompletion!.songLocalPath).to(equal("existingSong"))
                }

                it("does not persist the song url") {
                    expect(soundPersistence.calledUpdateSongUrl).to(beFalsy())
                }
            })

            context("When the song has no image and no sound file in the DB") {
                beforeEach {
                    song = Song(value: ["identifier": 384, "url": "songUrl", "albumArt": "imageUrl"])
                    subject.loadSongAssets(song: song, songCompletion: songCompletion, imageCompletion: imageCompletion)
                }

                it("downloads 2 files") {
                    expect(httpClient.downloadCallCount).to(equal(2))
                }

                itBehavesLike("downloading a song")

                itBehavesLike("downloading an image")
            }

            context("When the song has an image and no sound file in the DB") {
                context("When the file actually exists") {
                    beforeEach {
                        diskMaster.returnValueForIsMediaFilePresent = true

                        song = Song(value: ["identifier": 384, "url": "songUrl", "albumArt": "imageUrl", "imageLocalPath": "existingImage"])
                        subject.loadSongAssets(song: song, songCompletion: songCompletion, imageCompletion: imageCompletion)
                    }

                    it("downloads 1 files") {
                        expect(httpClient.downloadCallCount).to(equal(1))
                    }

                    it("checks to see if the file exists") {
                        expect(diskMaster.calledIsMediaFilePresent).to(beTruthy())
                        expect(diskMaster.capturedPathForMediaFilePresent).to(equal("existingImage"))
                    }

                    itBehavesLike("downloading a song")

                    itBehavesLike("not attempting to download an image")
                }

                context("When the file does not actually exist") {
                    beforeEach {
                        diskMaster.returnValueForIsMediaFilePresent = false

                        song = Song(value: ["identifier": 384, "url": "songUrl", "albumArt": "imageUrl", "imageLocalPath": "existingImage"])
                        subject.loadSongAssets(song: song, songCompletion: songCompletion, imageCompletion: imageCompletion)
                    }

                    it("downloads 2 files") {
                        expect(httpClient.downloadCallCount).to(equal(2))
                    }

                    it("checks to see if the file exists") {
                        expect(diskMaster.calledIsMediaFilePresent).to(beTruthy())
                        expect(diskMaster.capturedPathForMediaFilePresent).to(equal("existingImage"))
                    }

                    itBehavesLike("downloading a song")

                    itBehavesLike("downloading an image")
                }
            }

            context("When the song has a sound and no image file in the DB") {
                context("When the file actually exists") {
                    beforeEach {
                        diskMaster.returnValueForIsMediaFilePresent = true

                        song = Song(value: ["identifier": 384, "url": "songUrl", "albumArt": "imageUrl", "songLocalPath": "existingSong"])
                        subject.loadSongAssets(song: song, songCompletion: songCompletion, imageCompletion: imageCompletion)
                    }

                    it("downloads 1 files") {
                        expect(httpClient.downloadCallCount).to(equal(1))
                    }

                    it("checks to see if the file exists") {
                        expect(diskMaster.calledIsMediaFilePresent).to(beTruthy())
                        expect(diskMaster.capturedPathForMediaFilePresent).to(equal("existingSong"))
                    }

                    itBehavesLike("downloading an image")

                    itBehavesLike("not attempting to download a song")
                }

                context("When the file does not actually exist") {
                    beforeEach {
                        diskMaster.returnValueForIsMediaFilePresent = false

                        song = Song(value: ["identifier": 384, "url": "songUrl", "albumArt": "imageUrl", "songLocalPath": "existingSong"])
                        subject.loadSongAssets(song: song, songCompletion: songCompletion, imageCompletion: imageCompletion)
                    }

                    it("downloads 2 files") {
                        expect(httpClient.downloadCallCount).to(equal(2))
                    }

                    it("checks to see if the file exists") {
                        expect(diskMaster.calledIsMediaFilePresent).to(beTruthy())
                        expect(diskMaster.capturedPathForMediaFilePresent).to(equal("existingSong"))
                    }

                    itBehavesLike("downloading a song")

                    itBehavesLike("downloading an image")
                }
            }

            context("When the song has a sound and image file in the DB") {
                beforeEach {
                    diskMaster.returnValueForIsMediaFilePresent = true
                    song = Song(value: ["identifier": 384, "url": "songUrl", "albumArt": "imageUrl", "songLocalPath": "existingSong", "imageLocalPath": "existingImage"])
                    subject.loadSongAssets(song: song, songCompletion: songCompletion, imageCompletion: imageCompletion)
                }

                it("downloads 0 files") {
                    expect(httpClient.downloadCallCount).to(equal(0))
                }

                itBehavesLike("not attempting to download an image")

                itBehavesLike("not attempting to download a song")
            }
        }

    }
}
