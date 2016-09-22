import Quick
import Nimble
import Fleet
import RealmSwift
@testable import BestPractices

class SongPersistenceSpec: QuickSpec {
    
    override func spec() {
        
        var subject: SongPersistence!
        
        beforeEach {
            subject = SongPersistence()
            
            let realm = try! Realm()
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
                        Song(identifier: 256, name: "Private Eyes", artist: "Hall & Oates", url: "url1", albumArt: "album_art1"),
                        Song(identifier: 257, name: "Long Train Runnin", artist: "Doobie Brothers", url: "url2", albumArt: "album_art2"),
                    ]
                    subject.replace(songs)
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
                    beforeEach {
                        let songs = [
                            Song(identifier: 258, name: "Rich Girl", artist: "Hall & Oates", url: "url3", albumArt: "album_art3"),
                            Song(identifier: 257, name: "Long Train Runnin", artist: "Doobie Brothers", url: "url2", albumArt: "album_art2"),
                            Song(identifier: 259, name: "Sara Smile", artist: "Hall & Oates", url: "url4", albumArt: "album_art4"),
                        ]
                        subject.replace(songs)
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
                        
                        expect(result![1].identifier).to(equal(258))
                        expect(result![1].name).to(equal("Rich Girl"))
                        expect(result![1].artist).to(equal("Hall & Oates"))
                        expect(result![1].url).to(equal("url3"))
                        expect(result![1].albumArt).to(equal("album_art3"))
                        
                        expect(result![2].identifier).to(equal(259))
                        expect(result![2].name).to(equal("Sara Smile"))
                        expect(result![2].artist).to(equal("Hall & Oates"))
                        expect(result![2].url).to(equal("url4"))
                        expect(result![2].albumArt).to(equal("album_art4"))
                    }
                }
            }
        }

    }
}
