import Quick
import Nimble
import AVKit
import AVFoundation
@testable import BestPractices

class PlayerSpec: QuickSpec {
    override func spec() {

        var subject: Player!
        var engineBuilder: MockEngineBuilder!

        var playerNode: MockAVAudioPlayerNode!
        var engine: MockAVAudioEngine!
        var delayNodes: [MockAVAudioUnitDelay]!

        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "maneater", ofType: "mp3")!
        let sampleFileURL = URL(fileURLWithPath: path)
        let audioFile = try! AVAudioFile.init(forReading: sampleFileURL)

        beforeEach {
            subject = Player()

            engineBuilder = MockEngineBuilder()
            subject.engineBuilder = engineBuilder

            playerNode = MockAVAudioPlayerNode()
            engine = MockAVAudioEngine()
            delayNodes = [MockAVAudioUnitDelay(), MockAVAudioUnitDelay()]
        }

        describe(".loadSong") {
            it("does not initialize an audio player until we have a song file") {
                expect(subject.playerNode).to(beNil())
            }

            context("With a good URL") {
                beforeEach {
                    engineBuilder.returnPlayerValueForBuildEngine = playerNode
                    engineBuilder.returnEngineValueForBuildEngine = engine
                    engineBuilder.returnDelaysValueForBuildEngine = delayNodes
                }

                sharedExamples("building an engine") {
                    it("calls the engine builder") {
                        expect(engineBuilder.calledBuildEngine).to(beTruthy())
                        expect(engineBuilder.capturedAudioFile!.url).to(equal(sampleFileURL))
                    }

                    it("prepares the engine") {
                        expect(engine.calledPrepare).to(beTruthy())
                    }

                    it("attempts to start the engine") {
                        expect(engine.calledStart).to(beTruthy())
                    }
                }

                context("When the engine throws an exception") {
                    beforeEach {
                        engine.startShouldThrow = true
                        subject.loadSong(filePath: path)
                    }

                    itBehavesLike("building an engine")

                    it("does not store the player node") {
                        expect(subject.playerNode).to(beNil())
                    }

                    it("does not store the delay nodes") {
                        expect(subject.delayNodes).to(beNil())
                    }

                    it("does not store the engine") {
                        expect(subject.engine).to(beNil())
                    }

                    it("does not store the audio file") {
                        expect(subject.audioFile).to(beNil())
                    }
                }

                context("When the engine starts successfully") {
                    beforeEach {
                        engine.startShouldThrow = false
                        subject.loadSong(filePath: path)
                    }

                    itBehavesLike("building an engine")

                    it("stores the player node") {
                        expect(subject.playerNode).toNot(beNil())
                        expect(subject.playerNode).to(beIdenticalTo(playerNode))
                    }

                    it("stores the delay nodes") {
                        expect(subject.delayNodes).toNot(beNil())
                        expect(subject.delayNodes!.count).to(equal(2))
                    }

                    it("stores the engine") {
                        expect(subject.engine).toNot(beNil())
                        expect(subject.engine).to(beIdenticalTo(engine))
                    }

                    it("does not store the audio file") {
                        expect(subject.audioFile).toNot(beNil())
                        expect(subject.audioFile.url).to(equal(sampleFileURL))
                    }
                }
            }

            context("With a bad URL") {
                beforeEach {
                    subject.loadSong(filePath: "")
                }

                it("does not initialize an audio player until we have a song file") {
                    expect(subject.playerNode).to(beNil())
                }

                it("does not store the audio file") {
                    expect(subject.audioFile).to(beNil())
                }
            }
        }

        describe(".clearSong") {
            context("When a song has been loaded") {
                beforeEach {
                    subject.engine = engine
                    subject.playerNode = playerNode
                    subject.delayNodes = delayNodes
                    subject.audioFile = audioFile

                    subject.clearSong()
                }

                it("stops playing any song") {
                    expect(playerNode.calledStop).to(beTruthy())
                }

                it("wipes out all references to engine components") {
                    expect(subject.engine).to(beNil())
                    expect(subject.playerNode).to(beNil())
                    expect(subject.delayNodes).to(beNil())
                    expect(subject.audioFile).to(beNil())
                }
            }

            context("When a song has not been loaded") {
                beforeEach {
                    subject.engine = nil
                    subject.playerNode = nil
                    subject.delayNodes = nil
                    subject.audioFile = nil
                }

                it("does not raise an exception") {
                    expect(subject.clearSong()).toNot(throwError())
                }
            }
        }

        describe(".play") {
            context("When a song has been loaded") {
                beforeEach {
                    subject.engine = engine
                    subject.playerNode = playerNode
                    subject.delayNodes = delayNodes
                    subject.audioFile = audioFile
                }

                context("With delay") {
                    beforeEach {
                        for delayNode in delayNodes {
                            delayNode.bypass = true
                        }
                        subject.play(delay: true)
                    }

                    it("schedules playing the file") {
                        expect(playerNode.calledScheduleFile).to(beTruthy())
                        expect(playerNode.capturedFile!.url).to(equal(sampleFileURL))
                    }

                    it("plays the song") {
                        expect(playerNode.calledPlay).to(beTruthy())
                    }

                    it("turns on delay nodes") {
                        expect(delayNodes[0].bypass).to(beFalsy())
                        expect(delayNodes[1].bypass).to(beFalsy())
                    }
                }

                context("Without delay") {
                    beforeEach {
                        for delayNode in delayNodes {
                            delayNode.bypass = false
                        }
                        subject.play(delay: false)
                    }

                    it("schedules playing the file") {
                        expect(playerNode.calledScheduleFile).to(beTruthy())
                        expect(playerNode.capturedFile!.url).to(equal(sampleFileURL))
                    }

                    it("plays the song") {
                        expect(playerNode.calledPlay).to(beTruthy())
                    }

                    it("turns off delay nodes") {
                        expect(delayNodes[0].bypass).to(beTruthy())
                        expect(delayNodes[1].bypass).to(beTruthy())
                    }
                }

            }

            context("When a song has not been loaded") {
                beforeEach {
                    subject.engine = nil
                    subject.playerNode = nil
                    subject.delayNodes = nil
                    subject.audioFile = nil
                }

                it("does not raise an exception") {
                    expect(subject.play(delay: true)).toNot(throwError())
                }
            }
        }

    }
}
