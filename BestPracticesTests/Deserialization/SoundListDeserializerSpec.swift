import Quick
import Nimble
import SwiftyJSON
@testable import BestPractices

class SoundListDeserializerSpec: QuickSpec {
    override func spec() {

        var subject: SoundListDeserializer!

        beforeEach {
            subject = SoundListDeserializer()
        }

        describe(".deserialize") {
            var returnedSounds: [Sound]!

            context("When there are sounds to deserialize") {
                beforeEach {
                    let bundle = Bundle(for: type(of: self))
                    let path = bundle.path(forResource: "getSoundsListResponse", ofType: "json")!
                    let url = URL(fileURLWithPath: path)
                    let jsonData = try! Data(contentsOf: url)
                    let json = JSON(data: jsonData)
                    returnedSounds = subject.deserialize(json: json)
                }

                it("deserializes sound objects") {
                    expect(returnedSounds.count).to(equal(2))

                    expect(returnedSounds.first!.identifier).to(equal(1))
                    expect(returnedSounds.first!.name).to(equal("Maneater"))
                    expect(returnedSounds.first!.artist).to(equal("Hall & Oates"))
                    expect(returnedSounds.first!.url).to(equal("https://p.scdn.co/mp3-preview/85538cf6e2a89e0fe2c85049cff9eece282b7151"))
                    expect(returnedSounds.first!.albumArt).to(equal("https://i.scdn.co/image/02208eaf815fff1e5820380bbefa957f38148ea8"))

                    expect(returnedSounds.last!.identifier).to(equal(2))
                    expect(returnedSounds.last!.name).to(equal("Private Eyes"))
                    expect(returnedSounds.last!.artist).to(equal("Hall & Oates"))
                    expect(returnedSounds.last!.url).to(equal("https://p.scdn.co/mp3-preview/4a558e1144aba588135ba366ea5a705a3f653b94"))
                    expect(returnedSounds.last!.albumArt).to(equal("https://i.scdn.co/image/7c270ba6ca0991b05079aed0460628857270e7b2"))
                }
            }

            context("When there are no sounds") {
                beforeEach {
                    let jsonData = Data(base64Encoded: "[]", options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
                    let json = JSON(data: jsonData!)
                    returnedSounds = subject.deserialize(json: json)
                }

                it("deserializes an empty array") {
                    expect(returnedSounds.count).to(equal(0))
                }
            }

            context("When the server errors") {
                beforeEach {
                    returnedSounds = subject.deserialize(json: nil)
                }

                it("returns nil") {
                    expect(returnedSounds).to(beNil())
                }
            }
        }
    }
}


