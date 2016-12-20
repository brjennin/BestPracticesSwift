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

        describe("With no songs in the DB") {
            it("returns nil when trying to retreive") {
                expect(subject.retrieve()).to(beNil())
            }

            describe("Storing some items") {
                beforeEach {
                    let songs = [
                        Song(value: ["identifier": 256, "name": "Private Eyes", "artist": "Hall & Oates", "url": "url1", "albumArt": "album_art1"]),
                        Song(value: ["identifier": 257, "name": "Long Train Runnin", "artist": "Doobie Brothers", "url": "url2", "albumArt": "album_art2"]),
                    ]
                    subject.replace(sounds: songs)
                }

                it("wipes the local storage of songs and images") {
                    expect(diskMaster.calledWipeLocalStorage).to(beTruthy())
                }
                
                it("returns the songs when retrieving") {
                    let result = subject.retrieve()
                    expect(result).toNot(beNil())
                    expect(result!.count).to(equal(2))

                    expect(result!.first!.identifier).to(equal(256))
                    expect(result!.first!.name).to(equal("Private Eyes"))
                    expect(result!.first!.artist).to(equal("Hall & Oates"))
                    expect(result!.first!.url).to(equal("url1"))
                    expect(result!.first!.albumArt).to(equal("album_art1"))

                    expect(result!.last!.identifier).to(equal(257))
                    expect(result!.last!.name).to(equal("Long Train Runnin"))
                    expect(result!.last!.artist).to(equal("Doobie Brothers"))
                    expect(result!.last!.url).to(equal("url2"))
                    expect(result!.last!.albumArt).to(equal("album_art2"))
                }

                describe("Replacing with different songs") {
                    var songOne: Song!
                    var songTwo: Song!
                    var songThree: Song!
                    
                    beforeEach {
                        songOne = Song(value: ["identifier": 258, "name": "Rich Girl", "artist": "Hall & Oates", "url": "url3", "albumArt": "album_art3"])
                        songTwo = Song(value: ["identifier": 257, "name": "Long Train Runnin", "artist": "Doobie Brothers", "url": "url2", "albumArt": "album_art2"])
                        songThree = Song(value: ["identifier": 259, "name": "Sara Smile", "artist": "Hall & Oates", "url": "url4", "albumArt": "album_art4"])
                        
                        let songs: [Song] = [songOne, songTwo, songThree]
                        subject.replace(sounds: songs)
                    }

                    it("returns the songs when retrieving") {
                        let result = subject.retrieve()
                        expect(result).toNot(beNil())
                        expect(result!.count).to(equal(3))

                        expect(result![0].identifier).to(equal(257))
                        expect(result![0].name).to(equal("Long Train Runnin"))
                        expect(result![0].artist).to(equal("Doobie Brothers"))
                        expect(result![0].url).to(equal("url2"))
                        expect(result![0].albumArt).to(equal("album_art2"))
                        expect(result![0].imageLocalPath).to(beNil())
                        expect(result![0].songLocalPath).to(beNil())

                        expect(result![1].identifier).to(equal(258))
                        expect(result![1].name).to(equal("Rich Girl"))
                        expect(result![1].artist).to(equal("Hall & Oates"))
                        expect(result![1].url).to(equal("url3"))
                        expect(result![1].albumArt).to(equal("album_art3"))
                        expect(result![1].imageLocalPath).to(beNil())
                        expect(result![1].songLocalPath).to(beNil())
                        
                        expect(result![2].identifier).to(equal(259))
                        expect(result![2].name).to(equal("Sara Smile"))
                        expect(result![2].artist).to(equal("Hall & Oates"))
                        expect(result![2].url).to(equal("url4"))
                        expect(result![2].albumArt).to(equal("album_art4"))
                        expect(result![2].imageLocalPath).to(beNil())
                        expect(result![2].songLocalPath).to(beNil())
                    }
                    
                    describe("Updating urls for songs") {
                        beforeEach {
                            subject.updateLocalSoundUrl(sound: songTwo, url: "testurl")
                        }
                        
                        it("stores off the url for the song") {
                            expect(songTwo.songLocalPath).to(equal("testurl"))
                            let result = subject.retrieve()
                            expect(result![0].identifier).to(equal(257))
                            expect(result![0].songLocalPath).to(equal("testurl"))
                        }
                    }
                    
                    describe("Updating urls for images") {
                        beforeEach {
                            subject.updateLocalImageUrl(sound: songOne, url: "imageurl")
                        }
                        
                        it("stores off the url for the image") {
                            expect(songOne.imageLocalPath).to(equal("imageurl"))
                            let result = subject.retrieve()
                            expect(result![1].identifier).to(equal(258))
                            expect(result![1].imageLocalPath).to(equal("imageurl"))
                        }
                    }
                }
            }
        }

    }
}
