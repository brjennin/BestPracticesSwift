import Quick
import Nimble
@testable import BestPractices

class SoundLoaderSpec: QuickSpec {
    override func spec() {

        var subject: SoundLoader!
        var httpClient: MockHTTPClient!
        var soundPersistence: MockSoundPersistence!
        var diskMaster: MockDiskMaster!

        beforeEach {
            subject = SoundLoader()

            httpClient = MockHTTPClient()
            subject.httpClient = httpClient

            soundPersistence = MockSoundPersistence()
            subject.soundPersistence = soundPersistence

            diskMaster = MockDiskMaster()
            subject.diskMaster = diskMaster
        }

        describe(".loadSoundAssets") {
            var sound: Sound!

            let bundle = Bundle(for: type(of: self))

            var capturedSoundFromSoundCompletion: Sound?
            var calledSoundCompletion = false
            var capturedSoundFromImageCompletion: Sound?
            var calledImageCompletion = false

            let soundCompletion: ((Sound) -> ()) = { capturedSound in
                calledSoundCompletion = true
                capturedSoundFromSoundCompletion = capturedSound
            }
            let imageCompletion: ((Sound) -> ()) = { capturedSound in
                calledImageCompletion = true
                capturedSoundFromImageCompletion = capturedSound
            }

            sharedExamples("downloading a sound", closure: {
                it("calls the http client for the sound request") {
                    expect(httpClient.downloadUrls.first!).to(equal("soundUrl"))
                    expect(httpClient.downloadFolders.first!).to(equal("audio/384/"))
                }

                describe("When the sound completion resolves") {
                    context("When there is a URL") {
                        let path = bundle.path(forResource: "maneater", ofType: "mp3")!
                        let sampleFileURL = URL(fileURLWithPath: path)

                        beforeEach {
                            httpClient.downloadCompletions.first!(sampleFileURL)
                        }

                        it("calls the completion callback with a local url") {
                            expect(calledSoundCompletion).to(beTruthy())
                            expect(capturedSoundFromSoundCompletion!.identifier).to(equal(384))
                        }

                        it("persists the new sound url") {
                            expect(soundPersistence.calledUpdateSoundUrl).to(beTruthy())
                            expect(soundPersistence.capturedUpdateSoundUrlSound!.identifier).to(equal(384))
                            expect(soundPersistence.capturedUpdateSoundUrlUrl!).to(equal(sampleFileURL.path))
                        }
                    }

                    context("When there is no URL") {
                        beforeEach {
                            httpClient.downloadCompletions.first!(nil)
                        }

                        it("calls the completion callback with a nil local url") {
                            expect(calledSoundCompletion).to(beTruthy())
                            expect(capturedSoundFromSoundCompletion!.identifier).to(equal(384))
                        }

                        it("does not persist the new sound url") {
                            expect(soundPersistence.calledUpdateSoundUrl).to(beFalsy())
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
                            expect(capturedSoundFromImageCompletion!.identifier).to(equal(384))
                        }

                        it("persists the new sound url") {
                            expect(soundPersistence.calledUpdateImageUrl).to(beTruthy())
                            expect(soundPersistence.capturedUpdateImageUrlSound!.identifier).to(equal(384))
                            expect(soundPersistence.capturedUpdateImageUrlUrl!).to(equal(sampleFileURL.path))
                        }
                    }

                    context("When there is no URL") {
                        beforeEach {
                            httpClient.downloadCompletions.last!(nil)
                        }

                        it("calls the completion callback with a nil local url") {
                            expect(calledImageCompletion).to(beTruthy())
                            expect(capturedSoundFromImageCompletion!.identifier).to(equal(384))
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
                    expect(capturedSoundFromImageCompletion!.identifier).to(equal(384))
                    expect(capturedSoundFromImageCompletion!.imageLocalPath).to(equal("existingImage"))
                }

                it("does not persist the image url") {
                    expect(soundPersistence.calledUpdateImageUrl).to(beFalsy())
                }
            })

            sharedExamples("not attempting to download a sound", closure: {
                it("does not call the http client for the sound request") {
                    expect(httpClient.downloadUrls).toNot(contain("soundUrl"))
                }

                it("calls the completion callback with the existing url") {
                    expect(calledSoundCompletion).to(beTruthy())
                    expect(capturedSoundFromSoundCompletion!.identifier).to(equal(384))
                    expect(capturedSoundFromSoundCompletion!.soundLocalPath).to(equal("existingSound"))
                }

                it("does not persist the sound url") {
                    expect(soundPersistence.calledUpdateSoundUrl).to(beFalsy())
                }
            })

            context("When the sound has no image and no sound file in the DB") {
                beforeEach {
                    sound = Sound(value: ["identifier": 384, "url": "soundUrl", "albumArt": "imageUrl"])
                    subject.loadSoundAssets(sound: sound, soundCompletion: soundCompletion, imageCompletion: imageCompletion)
                }

                it("downloads 2 files") {
                    expect(httpClient.downloadCallCount).to(equal(2))
                }

                itBehavesLike("downloading a sound")

                itBehavesLike("downloading an image")
            }

            context("When the sound has an image and no sound file in the DB") {
                context("When the file actually exists") {
                    beforeEach {
                        diskMaster.returnValueForIsMediaFilePresent = true

                        sound = Sound(value: ["identifier": 384, "url": "soundUrl", "albumArt": "imageUrl", "imageLocalPath": "existingImage"])
                        subject.loadSoundAssets(sound: sound, soundCompletion: soundCompletion, imageCompletion: imageCompletion)
                    }

                    it("downloads 1 files") {
                        expect(httpClient.downloadCallCount).to(equal(1))
                    }

                    it("checks to see if the file exists") {
                        expect(diskMaster.calledIsMediaFilePresent).to(beTruthy())
                        expect(diskMaster.capturedPathForMediaFilePresent).to(equal("existingImage"))
                    }

                    itBehavesLike("downloading a sound")

                    itBehavesLike("not attempting to download an image")
                }

                context("When the file does not actually exist") {
                    beforeEach {
                        diskMaster.returnValueForIsMediaFilePresent = false

                        sound = Sound(value: ["identifier": 384, "url": "soundUrl", "albumArt": "imageUrl", "imageLocalPath": "existingImage"])
                        subject.loadSoundAssets(sound: sound, soundCompletion: soundCompletion, imageCompletion: imageCompletion)
                    }

                    it("downloads 2 files") {
                        expect(httpClient.downloadCallCount).to(equal(2))
                    }

                    it("checks to see if the file exists") {
                        expect(diskMaster.calledIsMediaFilePresent).to(beTruthy())
                        expect(diskMaster.capturedPathForMediaFilePresent).to(equal("existingImage"))
                    }

                    itBehavesLike("downloading a sound")

                    itBehavesLike("downloading an image")
                }
            }

            context("When the sound has a sound and no image file in the DB") {
                context("When the file actually exists") {
                    beforeEach {
                        diskMaster.returnValueForIsMediaFilePresent = true

                        sound = Sound(value: ["identifier": 384, "url": "soundUrl", "albumArt": "imageUrl", "soundLocalPath": "existingSound"])
                        subject.loadSoundAssets(sound: sound, soundCompletion: soundCompletion, imageCompletion: imageCompletion)
                    }

                    it("downloads 1 files") {
                        expect(httpClient.downloadCallCount).to(equal(1))
                    }

                    it("checks to see if the file exists") {
                        expect(diskMaster.calledIsMediaFilePresent).to(beTruthy())
                        expect(diskMaster.capturedPathForMediaFilePresent).to(equal("existingSound"))
                    }

                    itBehavesLike("downloading an image")

                    itBehavesLike("not attempting to download a sound")
                }

                context("When the file does not actually exist") {
                    beforeEach {
                        diskMaster.returnValueForIsMediaFilePresent = false

                        sound = Sound(value: ["identifier": 384, "url": "soundUrl", "albumArt": "imageUrl", "soundLocalPath": "existingSound"])
                        subject.loadSoundAssets(sound: sound, soundCompletion: soundCompletion, imageCompletion: imageCompletion)
                    }

                    it("downloads 2 files") {
                        expect(httpClient.downloadCallCount).to(equal(2))
                    }

                    it("checks to see if the file exists") {
                        expect(diskMaster.calledIsMediaFilePresent).to(beTruthy())
                        expect(diskMaster.capturedPathForMediaFilePresent).to(equal("existingSound"))
                    }

                    itBehavesLike("downloading a sound")

                    itBehavesLike("downloading an image")
                }
            }

            context("When the sound has a sound and image file in the DB") {
                beforeEach {
                    diskMaster.returnValueForIsMediaFilePresent = true
                    sound = Sound(value: ["identifier": 384, "url": "soundUrl", "albumArt": "imageUrl", "soundLocalPath": "existingSound", "imageLocalPath": "existingImage"])
                    subject.loadSoundAssets(sound: sound, soundCompletion: soundCompletion, imageCompletion: imageCompletion)
                }

                it("downloads 0 files") {
                    expect(httpClient.downloadCallCount).to(equal(0))
                }

                itBehavesLike("not attempting to download an image")

                itBehavesLike("not attempting to download a sound")
            }
        }

    }
}
