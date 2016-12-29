import Quick
import Nimble
import RealmSwift
@testable import BestPractices

class SoundPersistenceSpec: QuickSpec {

    override func spec() {

        var subject: SoundPersistence!
        var diskMaster: MockDiskMaster!
        let realm = try! Realm()
        
        beforeEach {
            subject = SoundPersistence()
            
            diskMaster = MockDiskMaster()
            subject.diskMaster = diskMaster            
        }
        
        beforeEach {
            try! realm.write {
                realm.deleteAll()
            }
        }
        
        afterEach {
            try! realm.write {
                realm.deleteAll()
            }
        }

        describe("With no sounds groups in the DB") {
            it("returns nil when trying to retreive") {
                expect(subject.retrieve()).to(beNil())
            }

            describe("Storing some items") {
                beforeEach {
                    let sounds = [
                        Sound(value: ["identifier": 256, "name": "Private Eyes", "artist": "Hall & Oates", "url": "url1", "albumArt": "album_art1"]),
                        Sound(value: ["identifier": 257, "name": "Long Train Runnin", "artist": "Doobie Brothers", "url": "url2", "albumArt": "album_art2"]),
                        ]
                    
                    let soundGroups = [
                        SoundGroup(value: ["identifier": 111, "name": "Yacht Rock", "sounds": sounds]),
                        SoundGroup(value: ["identifier": 222, "name": "Blank", "sounds": []]),
                    ]
                    
                    subject.replace(soundGroups: soundGroups)
                }

                it("wipes the local storage of sounds and images") {
                    expect(diskMaster.calledWipeLocalStorage).to(beTruthy())
                }
                
                it("returns the sound groups and sounds when retrieving") {
                    let result = subject.retrieve()
                    expect(result).toNot(beNil())
                    expect(result!.count).to(equal(2))
                    
                    expect(result!.first!.identifier).to(equal(111))
                    expect(result!.first!.name).to(equal("Yacht Rock"))
                    let yachtRockSounds = result!.first!.sounds
                    expect(yachtRockSounds.first!.identifier).to(equal(256))
                    expect(yachtRockSounds.first!.name).to(equal("Private Eyes"))
                    expect(yachtRockSounds.first!.artist).to(equal("Hall & Oates"))
                    expect(yachtRockSounds.first!.url).to(equal("url1"))
                    expect(yachtRockSounds.first!.albumArt).to(equal("album_art1"))
                    
                    expect(yachtRockSounds.last!.identifier).to(equal(257))
                    expect(yachtRockSounds.last!.name).to(equal("Long Train Runnin"))
                    expect(yachtRockSounds.last!.artist).to(equal("Doobie Brothers"))
                    expect(yachtRockSounds.last!.url).to(equal("url2"))
                    expect(yachtRockSounds.last!.albumArt).to(equal("album_art2"))
                    
                    expect(result!.last!.identifier).to(equal(222))
                    expect(result!.last!.name).to(equal("Blank"))
                    expect(result!.last!.sounds).to(beEmpty())
                }

                describe("Replacing with different sound groups") {
                    var soundOne: Sound!
                    var soundTwo: Sound!
                    var soundThree: Sound!
                    
                    beforeEach {
                        soundOne = Sound(value: ["identifier": 258, "name": "Rich Girl", "artist": "Hall & Oates", "url": "url3", "albumArt": "album_art3"])
                        soundTwo = Sound(value: ["identifier": 257, "name": "Long Train Runnin", "artist": "Doobie Brothers", "url": "url2", "albumArt": "album_art2"])
                        soundThree = Sound(value: ["identifier": 259, "name": "Sara Smile", "artist": "Hall & Oates", "url": "url4", "albumArt": "album_art4"])
                        
                        let soundGroups = [
                            SoundGroup(value: ["identifier": 123, "name": "Oates", "sounds": [soundOne, soundThree]]),
                            SoundGroup(value: ["identifier": 10, "name": "Doobie", "sounds": [soundTwo]]),
                            ]
                        
                        subject.replace(soundGroups: soundGroups)
                    }

                    it("returns the sound groups and sounds when retrieving") {
                        let result = subject.retrieve()
                        expect(result).toNot(beNil())
                        expect(result!.count).to(equal(2))

                        expect(result!.first!.identifier).to(equal(10))
                        expect(result!.first!.name).to(equal("Doobie"))
                        let doobieSounds = result!.first!.sounds
                        expect(doobieSounds.first!.identifier).to(equal(257))
                        expect(doobieSounds.first!.name).to(equal("Long Train Runnin"))
                        expect(doobieSounds.first!.artist).to(equal("Doobie Brothers"))
                        expect(doobieSounds.first!.url).to(equal("url2"))
                        expect(doobieSounds.first!.albumArt).to(equal("album_art2"))
                        expect(doobieSounds.first!.imageLocalPath).to(beNil())
                        expect(doobieSounds.first!.soundLocalPath).to(beNil())
                        
                        expect(result!.last!.identifier).to(equal(123))
                        expect(result!.last!.name).to(equal("Oates"))
                        let hallAndOatesSounds = result!.last!.sounds
                        expect(hallAndOatesSounds.first!.identifier).to(equal(258))
                        expect(hallAndOatesSounds.first!.name).to(equal("Rich Girl"))
                        expect(hallAndOatesSounds.first!.artist).to(equal("Hall & Oates"))
                        expect(hallAndOatesSounds.first!.url).to(equal("url3"))
                        expect(hallAndOatesSounds.first!.albumArt).to(equal("album_art3"))
                        expect(hallAndOatesSounds.first!.imageLocalPath).to(beNil())
                        expect(hallAndOatesSounds.first!.soundLocalPath).to(beNil())
                        
                        expect(hallAndOatesSounds.last!.identifier).to(equal(259))
                        expect(hallAndOatesSounds.last!.name).to(equal("Sara Smile"))
                        expect(hallAndOatesSounds.last!.artist).to(equal("Hall & Oates"))
                        expect(hallAndOatesSounds.last!.url).to(equal("url4"))
                        expect(hallAndOatesSounds.last!.albumArt).to(equal("album_art4"))
                        expect(hallAndOatesSounds.last!.imageLocalPath).to(beNil())
                        expect(hallAndOatesSounds.last!.soundLocalPath).to(beNil())
                    }
                    
                    describe("Updating urls for sounds") {
                        beforeEach {
                            subject.updateLocalSoundUrl(sound: soundTwo, url: "testurl")
                        }
                        
                        it("stores off the url for the sound") {
                            expect(soundTwo.soundLocalPath).to(equal("testurl"))
                            let result = subject.retrieve()
                            expect(result![0].sounds[0].identifier).to(equal(257))
                            expect(result![0].sounds[0].soundLocalPath).to(equal("testurl"))
                        }
                    }
                    
                    describe("Updating urls for images") {
                        beforeEach {
                            subject.updateLocalImageUrl(sound: soundOne, url: "imageurl")
                        }
                        
                        it("stores off the url for the image") {
                            expect(soundOne.imageLocalPath).to(equal("imageurl"))
                            let result = subject.retrieve()
                            expect(result![1].sounds[0].identifier).to(equal(258))
                            expect(result![1].sounds[0].imageLocalPath).to(equal("imageurl"))
                        }
                    }
                }
            }
        }

    }
}
