import Quick
import Nimble
import Fleet
import SwiftyJSON
@testable import BestPractices

class SongServiceSpec: QuickSpec {
    override func spec() {

        var subject: SongService!
        var requestProvider: MockRequestProvider!
        var httpClient: MockHTTPClient!
        var songListDeserializer: MockSongListDeserializer!

        beforeEach {
            subject = SongService()

            requestProvider = MockRequestProvider()
            subject.requestProvider = requestProvider

            httpClient = MockHTTPClient()
            subject.httpClient = httpClient

            songListDeserializer = MockSongListDeserializer()
            subject.songListDeserializer = songListDeserializer
        }

        describe(".getSongs") {
            var returnedSongs: [Song]!

            beforeEach {
                subject.getSongs({ songs in returnedSongs = songs })
            }

            it("gets a request from the request provider") {
                expect(requestProvider.calledGetSongsListRequest).to(beTruthy())
            }

            it("makes a request") {
                expect(httpClient.capturedJSONRequest!.urlString).to(equal("getSongsList"))
            }

            describe("When the HTTP call resolves") {
                context("When there are songs") {
                    var json: JSON!
                    var error: NSError!

                    beforeEach {
                        json = JSON(["thing1", "thing2"])
                        error = NSError(domain: "com.example", code: 123, userInfo: nil)
                        httpClient.capturedJSONCompletion!(json, error)
                    }

                    it("calls the deserializer") {
                        expect(songListDeserializer.calledDeserialize).to(beTruthy())
                        expect(songListDeserializer.capturedJSON!).to(equal(json))
                    }

                    it("calls the completion with song objects from the deserializer") {
                        expect(returnedSongs.first!.identifier).to(equal(123))
                        expect(returnedSongs.last!.identifier).to(equal(456))
                    }
                }
            }
        }

    }
}
