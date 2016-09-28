import Quick
import Nimble
import AVKit
import AVFoundation
@testable import BestPractices

class PlayerSpec: QuickSpec {
    override func spec() {

        var subject: Player!

        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "maneater", ofType: "mp3")!
        let sampleFileURL = URL(fileURLWithPath: path)
        
        beforeEach {
            subject = Player()
        }

        describe(".loadSong") {
            it("does not initialize an audio player until we have a song file") {
                expect(subject.audioPlayer).to(beNil())
            }
            
            context("With a good URL") {
                beforeEach {
                    subject.loadSong(filePath: path)
                }

                it("loads the song into the audio player") {
                    expect(subject.audioPlayer).toNot(beNil())
                    expect(subject.audioPlayer!.url!).to(equal(sampleFileURL))
                }
            }

            context("With a bad URL") {
                beforeEach {
                    subject.loadSong(filePath: "")
                }

                it("does not initialize an audio player until we have a song file") {
                    expect(subject.audioPlayer).to(beNil())
                }
            }
        }

        describe(".clearSong") {
            context("When there is a song loaded") {
                beforeEach {
                    subject.audioPlayer = try! AVAudioPlayer(contentsOf: sampleFileURL)
                    
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
                let bundle = Bundle(for: type(of: self))
                let path = bundle.path(forResource: "maneater", ofType: "mp3")!
                let sampleFileURL = URL(fileURLWithPath: path)
                let player = try! AVAudioPlayer(contentsOf: sampleFileURL)

                beforeEach {
                    subject.audioPlayer = player
                    subject.play()
                }

                afterEach {
                    subject.audioPlayer!.stop()
                }

                it("plays the song") {
                    expect(subject.audioPlayer!.isPlaying).to(beTruthy())
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
