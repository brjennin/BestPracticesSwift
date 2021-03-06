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

        describe(".getSounds") {
            var returnedSoundGroups: [SoundGroup]?
            var returnedError: NSError?

            beforeEach {
                subject.getSounds { sounds, error in
                    returnedSoundGroups = sounds
                    returnedError = error
                }
            }

            it("gets a request from the request provider") {
                expect(requestProvider.calledGetSoundsListRequest).to(beTruthy())
            }

            it("makes a request") {
                expect(httpClient.capturedJSONRequest!.urlString).to(equal("getSoundsList"))
            }

            describe("When the HTTP call resolves") {
                context("When there are sounds") {
                    var json: JSON!
                    var error: NSError!

                    beforeEach {
                        soundListDeserializer.returnValueForDeserialize = [
                            SoundGroup(value: ["identifier": 123]),
                            SoundGroup(value: ["identifier": 456])
                        ]

                        json = JSON(["thing1", "thing2"])
                        error = NSError(domain: "com.example", code: 123, userInfo: nil)
                        httpClient.capturedJSONCompletion!(json, error)
                    }

                    it("calls the deserializer") {
                        expect(soundListDeserializer.calledDeserialize).to(beTruthy())
                        expect(soundListDeserializer.capturedJSON!).to(equal(json))
                    }

                    it("calls the completion with sound group objects from the deserializer") {
                        expect(returnedSoundGroups!.first!.identifier).to(equal(123))
                        expect(returnedSoundGroups!.last!.identifier).to(equal(456))
                    }

                    it("bubbles up errors from the http client") {
                        expect(returnedError).to(beIdenticalTo(error))
                    }
                }

                context("When there are no sound groups") {
                    beforeEach {
                        soundListDeserializer.returnValueForDeserialize = nil

                        httpClient.capturedJSONCompletion!(nil, nil)
                    }

                    it("calls the deserializer") {
                        expect(soundListDeserializer.calledDeserialize).to(beTruthy())
                        expect(soundListDeserializer.capturedJSON).to(beNil())
                    }

                    it("doesn't have any returned sounds") {
                        expect(returnedSoundGroups).to(beNil())
                    }

                    it("doesn't have a returned error") {
                        expect(returnedError).to(beNil())
                    }
                }
            }
        }

    }
}
