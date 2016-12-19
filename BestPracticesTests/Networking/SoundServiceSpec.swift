import Quick
import Nimble
import SwiftyJSON
@testable import BestPractices

class SoundServiceSpec: QuickSpec {
    override func spec() {

        var subject: SoundService!
        var requestProvider: MockRequestProvider!
        var httpClient: MockHTTPClient!
        var soundListDeserializer: MockSoundListDeserializer!

        beforeEach {
            subject = SoundService()

            requestProvider = MockRequestProvider()
            subject.requestProvider = requestProvider

            httpClient = MockHTTPClient()
            subject.httpClient = httpClient

            soundListDeserializer = MockSoundListDeserializer()
            subject.soundListDeserializer = soundListDeserializer
        }

        describe(".getSongs") {
            var returnedSongs: [Song]?
            var returnedError: NSError?

            beforeEach {
                subject.getSongs { songs, error in
                    returnedSongs = songs
                    returnedError = error
                }
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
                        soundListDeserializer.returnValueForDeserialize = [
                            Song(value: ["identifier": 123]),
                            Song(value: ["identifier": 456])
                        ]

                        json = JSON(["thing1", "thing2"])
                        error = NSError(domain: "com.example", code: 123, userInfo: nil)
                        httpClient.capturedJSONCompletion!(json, error)
                    }

                    it("calls the deserializer") {
                        expect(soundListDeserializer.calledDeserialize).to(beTruthy())
                        expect(soundListDeserializer.capturedJSON!).to(equal(json))
                    }

                    it("calls the completion with song objects from the deserializer") {
                        expect(returnedSongs!.first!.identifier).to(equal(123))
                        expect(returnedSongs!.last!.identifier).to(equal(456))
                    }

                    it("bubbles up errors from the http client") {
                        expect(returnedError).to(beIdenticalTo(error))
                    }
                }

                context("When there are no songs") {
                    beforeEach {
                        soundListDeserializer.returnValueForDeserialize = nil

                        httpClient.capturedJSONCompletion!(nil, nil)
                    }

                    it("calls the deserializer") {
                        expect(soundListDeserializer.calledDeserialize).to(beTruthy())
                        expect(soundListDeserializer.capturedJSON).to(beNil())
                    }

                    it("doesn't have any returned songs") {
                        expect(returnedSongs).to(beNil())
                    }

                    it("doesn't have a returned error") {
                        expect(returnedError).to(beNil())
                    }
                }
            }
        }

    }
}
