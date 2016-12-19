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
            var returnedSongs: [Song]!

            context("When there are songs to deserialize") {
                beforeEach {
                    let bundle = Bundle(for: type(of: self))
                    let path = bundle.path(forResource: "getSongsListResponse", ofType: "json")!
                    let url = URL(fileURLWithPath: path)
                    let jsonData = try! Data(contentsOf: url)
                    let json = JSON(data: jsonData)
                    returnedSongs = subject.deserialize(json: json)
                }

                it("deserializes song objects") {
                    expect(returnedSongs.count).to(equal(2))

                    expect(returnedSongs.first!.identifier).to(equal(1))
                    expect(returnedSongs.first!.name).to(equal("Maneater"))
                    expect(returnedSongs.first!.artist).to(equal("Hall & Oates"))
                    expect(returnedSongs.first!.url).to(equal("https://p.scdn.co/mp3-preview/85538cf6e2a89e0fe2c85049cff9eece282b7151"))
                    expect(returnedSongs.first!.albumArt).to(equal("https://i.scdn.co/image/02208eaf815fff1e5820380bbefa957f38148ea8"))

                    expect(returnedSongs.last!.identifier).to(equal(2))
                    expect(returnedSongs.last!.name).to(equal("Private Eyes"))
                    expect(returnedSongs.last!.artist).to(equal("Hall & Oates"))
                    expect(returnedSongs.last!.url).to(equal("https://p.scdn.co/mp3-preview/4a558e1144aba588135ba366ea5a705a3f653b94"))
                    expect(returnedSongs.last!.albumArt).to(equal("https://i.scdn.co/image/7c270ba6ca0991b05079aed0460628857270e7b2"))
                }
            }

            context("When there are no songs") {
                beforeEach {
                    let jsonData = Data(base64Encoded: "[]", options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
                    let json = JSON(data: jsonData!)
                    returnedSongs = subject.deserialize(json: json)
                }

                it("deserializes an empty array") {
                    expect(returnedSongs.count).to(equal(0))
                }
            }

            context("When the server errors") {
                beforeEach {
                    returnedSongs = subject.deserialize(json: nil)
                }

                it("returns nil") {
                    expect(returnedSongs).to(beNil())
                }
            }
        }
    }
}


