import Quick
import Nimble
import AVKit
import AVFoundation
@testable import BestPractices

class PlayerSpec: QuickSpec {
    override func spec() {

        var subject: Player!
        var engineBuilder: MockEngineBuilder!
        var shiftTranslator: MockShiftTranslator!

        var audioBox: MockAudioBox!

        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "maneater", ofType: "mp3")!
        let sampleFileURL = URL(fileURLWithPath: path)
        let audioFile = try! AVAudioFile.init(forReading: sampleFileURL)

        beforeEach {
            subject = Player()

            engineBuilder = MockEngineBuilder()
            subject.engineBuilder = engineBuilder

            shiftTranslator = MockShiftTranslator()
            subject.shiftTranslator = shiftTranslator

            audioBox = MockAudioBox(file: audioFile, engine: MockAVAudioEngine(), player: MockAVAudioPlayerNode(), pitchShift: AVAudioUnitVarispeed(), delays: [])
        }

        describe(".loadSong") {
            it("does not initialize an audio box until we have a song file") {
                expect(subject.audioBox).to(beNil())
            }

            context("With a good URL") {
                beforeEach {
                    engineBuilder.returnAudioBoxValueForBuildEngine = audioBox
                }

                context("When the engine throws an exception") {
                    beforeEach {
                        audioBox.startShouldThrow = true
                        subject.loadSong(filePath: path)
                    }

                    it("calls the engine builder") {
                        expect(engineBuilder.calledBuildEngine).to(beTruthy())
                        expect(engineBuilder.capturedAudioFile!.url).to(equal(sampleFileURL))
                    }

                    it("starts the audio box") {
                        expect(audioBox.calledStart).to(beTruthy())
                    }

                    it("does not store the audio box") {
                        expect(subject.audioBox).to(beNil())
                    }
                }

                context("When the engine starts successfully") {
                    beforeEach {
                        audioBox.startShouldThrow = false
                        subject.loadSong(filePath: path)
                    }

                    it("calls the engine builder") {
                        expect(engineBuilder.calledBuildEngine).to(beTruthy())
                        expect(engineBuilder.capturedAudioFile!.url).to(equal(sampleFileURL))
                    }

                    it("starts the audio box") {
                        expect(audioBox.calledStart).to(beTruthy())
                    }

                    it("stores the audio box") {
                        expect(subject.audioBox).toNot(beNil())
                        expect(subject.audioBox).to(beIdenticalTo(audioBox))
                    }
                }
            }

            context("With a bad URL") {
                beforeEach {
                    subject.loadSong(filePath: "")
                }

                it("does not store the audio box") {
                    expect(subject.audioBox).to(beNil())
                }
            }
        }

        describe(".clearSong") {
            context("When a song has been loaded") {
                beforeEach {
                    subject.audioBox = audioBox
                    subject.clearSong()
                }

                it("stops playing any song") {
                    expect(audioBox.calledStop).to(beTruthy())
                }

                it("wipes out all references to engine components") {
                    expect(subject.audioBox).to(beNil())
                }
            }

            context("When a song has not been loaded") {
                beforeEach {
                    subject.audioBox = nil
                }

                it("does not raise an exception") {
                    expect(subject.clearSong()).toNot(throwError())
                }
            }
        }

        describe(".play") {
            context("When a song has been loaded") {
                beforeEach {
                    subject.audioBox = audioBox
                }

                context("With delay") {
                    beforeEach {
                        subject.play(delay: true)
                    }

                    it("plays the audio box with delay") {
                        expect(audioBox.calledPlay).to(beTruthy())
                        expect(audioBox.capturedDelay).to(beTruthy())
                    }
                }

                context("Without delay") {
                    beforeEach {
                        subject.play(delay: false)
                    }

                    it("plays the audio box with delay") {
                        expect(audioBox.calledPlay).to(beTruthy())
                        expect(audioBox.capturedDelay).to(beFalsy())
                    }
                }
            }

            context("When a song has not been loaded") {
                beforeEach {
                    subject.audioBox = nil
                }

                it("does not raise an exception") {
                    expect(subject.play(delay: true)).toNot(throwError())
                }
            }
        }

        describe(".pitchShift") {
            context("When a song has been loaded") {
                beforeEach {
                    subject.audioBox = audioBox
                    subject.clearSong()
                }

                it("stops playing any song") {
                    expect(audioBox.calledStop).to(beTruthy())
                }

                it("wipes out all references to engine components") {
                    expect(subject.audioBox).to(beNil())
                }
            }

            context("When a song has not been loaded") {
                beforeEach {
                    subject.audioBox = nil
                }

                it("does not raise an exception") {
                    expect(subject.clearSong()).toNot(throwError())
                }
            }
        }

        describe(".pitchShift") {
            context("When a song is loaded") {
                beforeEach {
                    subject.audioBox = audioBox

                    shiftTranslator.returnValueForTranslation = 3.5
                    subject.pitchShift(amount: 1.2)
                }

                it("calls the shift translator") {
                    expect(shiftTranslator.calledTranslate).to(beTruthy())
                    expect(shiftTranslator.capturedInputValue).to(equal(1.2))
                }

                it("sets the shift node to the translated value") {
                    expect(audioBox.calledPitchShift).to(beTruthy())
                    expect(audioBox.capturedPitchShiftAmount).to(equal(3.5))
                }
            }

            context("When a song is not loaded") {
                beforeEach {
                    subject.audioBox = nil
                    subject.pitchShift(amount: 1.2)
                }

                it("does not call the shift translator") {
                    expect(shiftTranslator.calledTranslate).to(beFalsy())
                }
            }
        }

    }
}
