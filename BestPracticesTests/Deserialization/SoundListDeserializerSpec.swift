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
            var returnedSoundGroups: [SoundGroup]!

            context("When there are sounds to deserialize") {
                beforeEach {
                    let bundle = Bundle(for: type(of: self))
                    let path = bundle.path(forResource: "getSoundsListResponse", ofType: "json")!
                    let url = URL(fileURLWithPath: path)
                    let jsonData = try! Data(contentsOf: url)
                    let json = JSON(data: jsonData)
                    returnedSoundGroups = subject.deserialize(json: json)
                }

                it("deserializes sound group objects") {
                    expect(returnedSoundGroups.count).to(equal(2))
                }
                
                it("deserializes sound objects") {
                    let yachtRockGroup = returnedSoundGroups.first!.sounds
                    expect(yachtRockGroup.count).to(equal(2))
                    
                    expect(yachtRockGroup.first!.identifier).to(equal(1))
                    expect(yachtRockGroup.first!.name).to(equal("Maneater"))
                    expect(yachtRockGroup.first!.artist).to(equal("Hall & Oates"))
                    expect(yachtRockGroup.first!.url).to(equal("https://p.scdn.co/mp3-preview/85538cf6e2a89e0fe2c85049cff9eece282b7151"))
                    expect(yachtRockGroup.first!.albumArt).to(equal("https://i.scdn.co/image/02208eaf815fff1e5820380bbefa957f38148ea8"))

                    expect(yachtRockGroup.last!.identifier).to(equal(2))
                    expect(yachtRockGroup.last!.name).to(equal("Private Eyes"))
                    expect(yachtRockGroup.last!.artist).to(equal("Hall & Oates"))
                    expect(yachtRockGroup.last!.url).to(equal("https://p.scdn.co/mp3-preview/4a558e1144aba588135ba366ea5a705a3f653b94"))
                    expect(yachtRockGroup.last!.albumArt).to(equal("https://i.scdn.co/image/7c270ba6ca0991b05079aed0460628857270e7b2"))
                    
                    let oceanSoundsGroup = returnedSoundGroups.last!.sounds
                    expect(oceanSoundsGroup.first!.identifier).to(equal(3))
                    expect(oceanSoundsGroup.first!.name).to(equal("Flipper"))
                    expect(oceanSoundsGroup.first!.artist).to(equal("Dolphin"))
                    expect(oceanSoundsGroup.first!.url).to(equal("https://example.com/dolphin.mp3"))
                    expect(oceanSoundsGroup.first!.albumArt).to(equal("https://example.com/dolphin.jpg"))
                }
            }

            context("When there are no sound groups") {
                beforeEach {
                    let jsonData = Data(base64Encoded: "[]", options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
                    let json = JSON(data: jsonData!)
                    returnedSoundGroups = subject.deserialize(json: json)
                }

                it("deserializes an empty array") {
                    expect(returnedSoundGroups.count).to(equal(0))
                }
            }

            context("When the server errors") {
                beforeEach {
                    returnedSoundGroups = subject.deserialize(json: nil)
                }

                it("returns nil") {
                    expect(returnedSoundGroups).to(beNil())
                }
            }
        }
    }
}


