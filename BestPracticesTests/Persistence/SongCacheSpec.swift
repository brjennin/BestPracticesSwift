import Quick
import Nimble
import Fleet
@testable import BestPractices

class SongCacheSpec: QuickSpec {

    override func spec() {

        var subject: SongCache!
        var songService: MockSongService!
        var songPersistence: MockSongPersistence!

        beforeEach {
            subject = SongCache()

            songService = MockSongService()
            subject.songService = songService

            songPersistence = MockSongPersistence()
            subject.songPersistence = songPersistence
        }

        describe(".getSongsAndRefreshCache") {
            var result: [Song]!
            var songOne: Song!
            var songTwo: Song!
            var songs: [Song]!

            beforeEach {
                songOne = Song(value: ["identifier": 111])
                songTwo = Song(value: ["identifier": 222])
                songs = [songOne, songTwo]

                subject.getSongsAndRefreshCache { returnedSongs in
                    result = returnedSongs
                }
            }

            it("calls the SongService") {
                expect(songService.calledService).to(beTruthy())
            }

            describe("When the service resolves") {
                beforeEach {
                    songService.completion!(songs)
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

                it("retrieves songs from the persistence layer") {
                    expect(songPersistence.calledRetrieve).to(beTruthy())
                }

                it("calls the SongService") {
                    expect(songService.calledService).to(beTruthy())
                }

                describe("When the service resolves") {
                    beforeEach {
                        let songs = [
                            Song(value: ["identifier": 743]),
                            Song(value: ["identifier": 148]),
                        ]
                        songService.completion!(songs)
                    }

                    it("calls the completion with the song list") {
                        expect(result.count).to(equal(2))
                        expect(result.first!.identifier).to(equal(743))
                        expect(result.last!.identifier).to(equal(148))
                    }

                    it("persists the songs") {
                        expect(songPersistence.calledReplace).to(beTruthy())
                        expect(songPersistence.capturedReplaceSongs!.first!.identifier).to(equal(743))
                        expect(songPersistence.capturedReplaceSongs!.last!.identifier).to(equal(148))
                    }
                }
            }
        }

    }
}