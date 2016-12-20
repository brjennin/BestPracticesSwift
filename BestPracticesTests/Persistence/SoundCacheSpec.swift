import Quick
import Nimble
@testable import BestPractices

class SoundCacheSpec: QuickSpec {

    override func spec() {

        var subject: SoundCache!
        var soundService: MockSoundService!
        var soundPersistence: MockSoundPersistence!

        var result: [Song]!

        beforeEach {
            subject = SoundCache()

            soundService = MockSoundService()
            subject.soundService = soundService

            soundPersistence = MockSoundPersistence()
            subject.soundPersistence = soundPersistence
        }

        describe(".getSongsAndRefreshCache") {
            beforeEach {
                subject.getSoundsAndRefreshCache { returnedSongs in
                    result = returnedSongs
                }
            }

            it("calls the SoundService") {
                expect(soundService.calledService).to(beTruthy())
            }

            describe("When the service resolves") {
                context("When it resolves with songs") {
                    var soundOne: Song!
                    var soundTwo: Song!
                    var sounds: [Song]!

                    beforeEach {
                        soundOne = Song(value: ["identifier": 111])
                        soundTwo = Song(value: ["identifier": 222])
                        sounds = [soundOne, soundTwo]

                        soundService.completion!(sounds, nil)
                    }

                    it("calls the completion with the song list") {
                        expect(result.count).to(equal(2))
                        expect(result.first!.identifier).to(equal(111))
                        expect(result.last!.identifier).to(equal(222))
                    }

                    it("persists the songs") {
                        expect(soundPersistence.calledReplace).to(beTruthy())
                        expect(soundPersistence.capturedReplaceSounds!.first!.identifier).to(equal(111))
                        expect(soundPersistence.capturedReplaceSounds!.last!.identifier).to(equal(222))
                    }
                }

                context("When it resolves without songs") {
                    let error = NSError(domain: "com.example", code: 213, userInfo: nil)

                    context("When there are songs persisted") {
                        beforeEach {
                            soundPersistence.soundsThatGetRetrieved = [
                                Song(value: ["identifier": 831]),
                                Song(value: ["identifier": 821]),
                            ]

                            soundService.completion!(nil, error)
                        }

                        it("does not replace the songs in the persistence layer") {
                            expect(soundPersistence.calledReplace).to(beFalsy())
                        }

                        it("retrieves songs from the persistence layer") {
                            expect(soundPersistence.calledRetrieve).to(beTruthy())
                        }

                        it("calls the completion with the result from the persistence layer") {
                            expect(result.first!.identifier).to(equal(831))
                            expect(result.last!.identifier).to(equal(821))
                        }
                    }

                    context("When there are no songs persisted") {
                        beforeEach {
                            soundPersistence.soundsThatGetRetrieved = nil
                            soundService.completion!(nil, error)
                        }

                        it("does not replace the songs in the persistence layer") {
                            expect(soundPersistence.calledReplace).to(beFalsy())
                        }

                        it("retrieves songs from the persistence layer") {
                            expect(soundPersistence.calledRetrieve).to(beTruthy())
                        }

                        it("calls the completion with an empty array") {
                            expect(result.count).to(equal(0))
                        }
                    }

                }
            }

        }

        describe(".getSongs") {
            var result: [Song]!

            beforeEach {
                soundService.reset()
            }

            context("When the persistence layer has songs") {
                beforeEach {
                    soundPersistence.soundsThatGetRetrieved = [
                        Song(value: ["identifier": 831]),
                        Song(value: ["identifier": 821]),
                    ]

                    subject.getSounds { returnedSongs in
                        result = returnedSongs
                    }
                }

                it("retrieves songs from the persistence layer") {
                    expect(soundPersistence.calledRetrieve).to(beTruthy())
                }

                it("does not call the service") {
                    expect(soundService.calledService).to(beFalsy())
                }

                it("calls the completion with the result from the persistence layer") {
                    expect(result.first!.identifier).to(equal(831))
                    expect(result.last!.identifier).to(equal(821))
                }
            }

            context("When the persistence layer has no songs") {
                beforeEach {
                    soundPersistence.soundsThatGetRetrieved = nil

                    subject.getSounds { returnedSongs in
                        result = returnedSongs
                    }
                }

                it("tries to retrieve songs from the persistence layer") {
                    expect(soundPersistence.calledRetrieve).to(beTruthy())
                }

                it("calls the SoundService") {
                    expect(soundService.calledService).to(beTruthy())
                }

                describe("When the service resolves") {
                    context("When it resolves with songs") {
                        var songOne: Song!
                        var songTwo: Song!
                        var songs: [Song]!

                        beforeEach {
                            songOne = Song(value: ["identifier": 111])
                            songTwo = Song(value: ["identifier": 222])
                            songs = [songOne, songTwo]

                            soundService.completion!(songs, nil)
                        }

                        it("calls the completion with the song list") {
                            expect(result.count).to(equal(2))
                            expect(result.first!.identifier).to(equal(111))
                            expect(result.last!.identifier).to(equal(222))
                        }

                        it("persists the songs") {
                            expect(soundPersistence.calledReplace).to(beTruthy())
                            expect(soundPersistence.capturedReplaceSounds!.first!.identifier).to(equal(111))
                            expect(soundPersistence.capturedReplaceSounds!.last!.identifier).to(equal(222))
                        }
                    }

                    context("When it resolves without songs") {
                        let error = NSError(domain: "com.example", code: 213, userInfo: nil)

                        beforeEach {
                            soundPersistence.soundsThatGetRetrieved = nil
                            soundService.completion!(nil, error)
                        }

                        it("does not replace the songs in the persistence layer") {
                            expect(soundPersistence.calledReplace).to(beFalsy())
                        }

                        it("calls the completion with an empty array") {
                            expect(result.count).to(equal(0))
                        }
                    }
                }
            }
        }

    }
}
