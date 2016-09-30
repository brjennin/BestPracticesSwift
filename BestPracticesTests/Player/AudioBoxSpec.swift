import Quick
import Nimble
import AVKit
import AVFoundation

@testable import BestPractices

class AudioBoxSpec: QuickSpec {
    override func spec() {

        var subject: AudioBox!

        var engine: MockAVAudioEngine!
        var player: MockAVAudioPlayerNode!
        var pitchShift: AVAudioUnitVarispeed!
        var delays: [MockAVAudioUnitDelay]!
        var reverb: AVAudioUnitReverb!

        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "maneater", ofType: "mp3")!
        let sampleFileURL = URL(fileURLWithPath: path)
        let audioFile = try! AVAudioFile.init(forReading: sampleFileURL)

        beforeEach {
            engine = MockAVAudioEngine()
            player = MockAVAudioPlayerNode()
            pitchShift = AVAudioUnitVarispeed()
            delays = [MockAVAudioUnitDelay(), MockAVAudioUnitDelay()]
            reverb = AVAudioUnitReverb()

            subject = AudioBox(file: audioFile, engine: engine, player: player, pitchShift: pitchShift, delays: delays, reverb: reverb)
        }

        it("stores off the values it is initialized with in properties") {
            expect(subject.engine).to(beIdenticalTo(engine))
            expect(subject.player).to(beIdenticalTo(player))
            expect(subject.pitchShift).to(beIdenticalTo(pitchShift))
            expect(subject.delays[0]).to(beIdenticalTo(delays[0]))
            expect(subject.delays[1]).to(beIdenticalTo(delays[1]))
            expect(subject.file).to(beIdenticalTo(audioFile))
            expect(subject.reverb).to(beIdenticalTo(reverb))
        }

        describe(".start") {
            context("When starting raises an exception") {
                var threwError: Bool!

                beforeEach {
                    threwError = false
                    engine.startShouldThrow = true
                    do {
                        try subject.start()
                    } catch {
                        threwError = true
                    }
                }

                it("raises an exception") {
                    expect(threwError).to(beTruthy())
                }
            }

            context("When starting is successful") {
                beforeEach {
                    engine.startShouldThrow = false
                    try! subject.start()
                }

                it("prepares the engine") {
                    expect(engine.calledPrepare).to(beTruthy())
                }

                it("attempts to start the engine") {
                    expect(engine.calledStart).to(beTruthy())
                }
            }
        }

        describe(".stop") {
            beforeEach {
                subject.stop()
            }

            it("tells the player to stop") {
                expect(player.calledStop).to(beTruthy())
            }
        }

        describe(".play") {
            context("With delay") {
                beforeEach {
                    for delayNode in delays {
                        delayNode.bypass = true
                    }
                }
                
                sharedExamples("playing a song") {
                    it("schedules playing the file") {
                        expect(player.calledScheduleFile).to(beTruthy())
                        expect(player.capturedFile!).to(beIdenticalTo(audioFile))
                    }
                    
                    it("plays the song") {
                        expect(player.calledPlay).to(beTruthy())
                    }
                }
                
                context("With reverb") {
                    beforeEach {
                        reverb.wetDryMix = 0
                        subject.play(delay: true, reverb: true)
                    }

                    itBehavesLike("playing a song")
                    
                    it("turns on delay nodes") {
                        expect(delays[0].bypass).to(beFalsy())
                        expect(delays[1].bypass).to(beFalsy())
                    }
                    
                    it("turns on reverb") {
                        expect(reverb.wetDryMix).to(equal(AudioBox.reverbAmount))
                    }
                }
                
                context("Without reverb") {
                    beforeEach {
                        reverb.wetDryMix = AudioBox.reverbAmount
                        subject.play(delay: true, reverb: false)
                    }
                    
                    itBehavesLike("playing a song")
                    
                    it("turns on delay nodes") {
                        expect(delays[0].bypass).to(beFalsy())
                        expect(delays[1].bypass).to(beFalsy())
                    }
                    
                    it("turns off reverb") {
                        expect(reverb.wetDryMix).to(equal(0))
                    }
                }
            }

            context("Without delay") {
                beforeEach {
                    for delayNode in delays {
                        delayNode.bypass = false
                    }
                }

                context("With reverb") {
                    beforeEach {
                        reverb.wetDryMix = 0
                        subject.play(delay: false, reverb: true)
                    }
                    
                    itBehavesLike("playing a song")
                    
                    it("turns off delay nodes") {
                        expect(delays[0].bypass).to(beTruthy())
                        expect(delays[1].bypass).to(beTruthy())
                    }
                    
                    it("turns on reverb") {
                        expect(reverb.wetDryMix).to(equal(AudioBox.reverbAmount))
                    }
                }
                
                context("Without reverb") {
                    beforeEach {
                        reverb.wetDryMix = AudioBox.reverbAmount
                        subject.play(delay: false, reverb: false)
                    }
                    
                    itBehavesLike("playing a song")
                    
                    it("turns off delay nodes") {
                        expect(delays[0].bypass).to(beTruthy())
                        expect(delays[1].bypass).to(beTruthy())
                    }
                    
                    it("turns off reverb") {
                        expect(reverb.wetDryMix).to(equal(0))
                    }
                }
            }
        }

        describe(".pitchShift") {
            beforeEach {
                subject.pitchShift.rate = 1
                subject.pitchShift(amount: 1.2)
            }

            it("sets the shift node to the value") {
                expect(subject.pitchShift.rate).to(equal(1.2))
            }
        }

    }
}
