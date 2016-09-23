import Quick
import Nimble
import Fleet
import AVKit
import AVFoundation
@testable import BestPractices

class PlayerSpec: QuickSpec {
    override func spec() {

        var subject: Player!

        let bundle = NSBundle(forClass: self.dynamicType)
        let path = bundle.pathForResource("maneater", ofType: "mp3")!
        let sampleFileURL = NSURL(fileURLWithPath: path)
        
        beforeEach {
            subject = Player()
        }

        describe(".loadSong") {
            it("does not initialize an audio player until we have a song file") {
                expect(subject.audioPlayer).to(beNil())
            }
            
            context("With a good URL") {
                beforeEach {
                    subject.loadSong(path)
                }

                it("loads the song into the audio player") {
                    expect(subject.audioPlayer).toNot(beNil())
                    expect(subject.audioPlayer!.url!).to(equal(sampleFileURL))
                }
            }

            context("With a bad URL") {
                beforeEach {
                    subject.loadSong("")
                }

                it("does not initialize an audio player until we have a song file") {
                    expect(subject.audioPlayer).to(beNil())
                }
            }
        }

        describe(".clearSong") {
            context("When there is a song loaded") {
                beforeEach {
                    subject.audioPlayer = try! AVAudioPlayer(contentsOfURL: sampleFileURL)
                    
                    subject.clearSong()
                }
                
                it("clears the audio player") {
                    expect(subject.audioPlayer).to(beNil())
                }
            }
            
            context("When there is no song loaded") {
                beforeEach {
                    subject.audioPlayer = nil
                    
                    subject.clearSong()
                }
                
                it("clears the audio player") {
                    expect(subject.audioPlayer).to(beNil())
                }
            }
        }
        
        describe(".play") {
            context("When there is a song loaded") {
                let bundle = NSBundle(forClass: self.dynamicType)
                let path = bundle.pathForResource("maneater", ofType: "mp3")!
                let sampleFileURL = NSURL(fileURLWithPath: path)
                let player = try! AVAudioPlayer(contentsOfURL: sampleFileURL)

                beforeEach {
                    subject.audioPlayer = player
                    subject.play()
                }

                afterEach {
                    subject.audioPlayer!.stop()
                }

                it("plays the song") {
                    expect(subject.audioPlayer!.playing).to(beTruthy())
                }
            }

            context("When there is no song loaded") {
                beforeEach {
                    subject.audioPlayer = nil
                }

                it("plays the song") {
                    expect(subject.play()).toNot(throwError())
                }
            }
        }

    }
}
