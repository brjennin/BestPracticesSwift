import Quick
import Nimble
import Fleet
@testable import BestPractices

class SongCacheSpec: QuickSpec {

    override func spec() {

        var subject: SongCache!
        var songService: MockSongService!
        var songPersistence: MockSongPersistence!

        var result: [Song]!

        beforeEach {
            subject = SongCache()

            songService = MockSongService()
            subject.songService = songService

            songPersistence = MockSongPersistence()
            subject.songPersistence = songPersistence
        }

        describe(".getSongsAndRefreshCache") {
            beforeEach {
                subject.getSongsAndRefreshCache { returnedSongs in
                    result = returnedSongs
                }
            }

            it("calls the SongService") {
                expect(songService.calledService).to(beTruthy())
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

                        songService.completion!(songs, nil)
                    }

                    it("calls the completion with the song list") {
                        expect(result.count).to(equal(2))
                        expect(result.first!.identifier).to(equal(111))
                        expect(result.last!.identifier).to(equal(222))
                    }

                    it("persists the songs") {
                        expect(songPersistence.calledReplace).to(beTruthy())
                        expect(songPersistence.capturedReplaceSongs!.first!.identifier).to(equal(111))
                        expect(songPersistence.capturedReplaceSongs!.last!.identifier).to(equal(222))
                    }
                }

                context("When it resolves without songs") {
                    let error = NSError(domain: "com.example", code: 213, userInfo: nil)

                    context("When there are songs persisted") {
                        beforeEach {
                            songPersistence.songsThatGetRetrieved = [
                                Song(value: ["identifier": 831]),
                                Song(value: ["identifier": 821]),
                            ]

                            songService.completion!(nil, error)
                        }

                        it("does not replace the songs in the persistence layer") {
                            expect(songPersistence.calledReplace).to(beFalsy())
                        }

                        it("retrieves songs from the persistence layer") {
                            expect(songPersistence.calledRetrieve).to(beTruthy())
                        }

                        it("calls the completion with the result from the persistence layer") {
                            expect(result.first!.identifier).to(equal(831))
                            expect(result.last!.identifier).to(equal(821))
                        }
                    }

                    context("When there are no songs persisted") {
                        beforeEach {
                            songPersistence.songsThatGetRetrieved = nil
                            songService.completion!(nil, error)
                        }

                        it("does not replace the songs in the persistence layer") {
                            expect(songPersistence.calledReplace).to(beFalsy())
                        }

                        it("retrieves songs from the persistence layer") {
                            expect(songPersistence.calledRetrieve).to(beTruthy())
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
                songService.reset()
            }

            context("When the persistence layer has songs") {
                beforeEach {
                    songPersistence.songsThatGetRetrieved = [
                        Song(value: ["identifier": 831]),
                        Song(value: ["identifier": 821]),
                    ]

                    subject.getSongs { returnedSongs in
                        result = returnedSongs
                    }
                }

                it("retrieves songs from the persistence layer") {
                    expect(songPersistence.calledRetrieve).to(beTruthy())
                }

                it("does not call the service") {
                    expect(songService.calledService).to(beFalsy())
                }

                it("calls the completion with the result from the persistence layer") {
                    expect(result.first!.identifier).to(equal(831))
                    expect(result.last!.identifier).to(equal(821))
                }
            }

            context("When the persistence layer has no songs") {
                beforeEach {
                    songPersistence.songsThatGetRetrieved = nil

                    subject.getSongs { returnedSongs in
                        result = returnedSongs
                    }
                }

                it("tries to retrieve songs from the persistence layer") {
                    expect(songPersistence.calledRetrieve).to(beTruthy())
                }

                it("calls the SongService") {
                    expect(songService.calledService).to(beTruthy())
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

                            songService.completion!(songs, nil)
                        }

                        it("calls the completion with the song list") {
                            expect(result.count).to(equal(2))
                            expect(result.first!.identifier).to(equal(111))
                            expect(result.last!.identifier).to(equal(222))
                        }

                        it("persists the songs") {
                            expect(songPersistence.calledReplace).to(beTruthy())
                            expect(songPersistence.capturedReplaceSongs!.first!.identifier).to(equal(111))
                            expect(songPersistence.capturedReplaceSongs!.last!.identifier).to(equal(222))
                        }
                    }

                    context("When it resolves without songs") {
                        let error = NSError(domain: "com.example", code: 213, userInfo: nil)

                        beforeEach {
                            songPersistence.songsThatGetRetrieved = nil
                            songService.completion!(nil, error)
                        }

                        it("does not replace the songs in the persistence layer") {
                            expect(songPersistence.calledReplace).to(beFalsy())
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
