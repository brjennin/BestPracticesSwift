import Quick
import Nimble
import AVKit
import AVFoundation
@testable import BestPractices

class EngineBuilderSpec: QuickSpec {
    override func spec() {

        var subject: EngineBuilder!

        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "maneater", ofType: "mp3")!
        let sampleFileURL = URL(fileURLWithPath: path)
        let audioFile = try! AVAudioFile.init(forReading: sampleFileURL)

        beforeEach {
            subject = EngineBuilder()
        }

        describe(".buildEngine") {
            var player: AVAudioPlayerNode!
            var engine: AVAudioEngine!
            var delayNodes: [AVAudioUnitDelay]!
            var reverb: AVAudioUnitReverb!
            var pitchShift: AVAudioUnitVarispeed!
            var eq: AVAudioUnitEQ!

            var audioBox: AudioBox!

            beforeEach {
                audioBox = subject.buildEngine(audioFile: audioFile) as! AudioBox
                player = audioBox.player as! AVAudioPlayerNode
                engine = audioBox.engine as! AVAudioEngine
                delayNodes = audioBox.delays as! [AVAudioUnitDelay]
                pitchShift = audioBox.pitchShift
                reverb = audioBox.reverb
                eq = audioBox.eq
            }

            it("returns a fully hydrated audio box") {
                expect(audioBox.file).toNot(beNil())
                expect(audioBox.engine).toNot(beNil())
                expect(audioBox.player).toNot(beNil())
                expect(audioBox.pitchShift).toNot(beNil())
                expect(audioBox.delays.count).to(equal(5))
                expect(audioBox.reverb).toNot(beNil())
                expect(audioBox.eq).toNot(beNil())
            }

            it("correctly sets up each delay node") {
                for node in delayNodes {
                    expect(node.delayTime).to(equal(2))
                    expect(node.feedback).to(equal(0))
                    expect(node.wetDryMix).to(equal(100))
                    expect(node.lowPassCutoff).to(equal(20000))
                    expect(node.outputFormat(forBus: 0)).to(equal(audioFile.processingFormat))
                }
            }

            it("correctly sets up the pitch shift node") {
                expect(pitchShift.rate).to(equal(1))
                expect(pitchShift.outputFormat(forBus: 0)).to(equal(audioFile.processingFormat))
            }

            it("correctly sets up the reverb node") {
                expect(reverb.wetDryMix).to(equal(0))
                expect(reverb.outputFormat(forBus: 0)).to(equal(audioFile.processingFormat))
            }

            it("correctly sets up the eq node") {
                expect(eq.outputFormat(forBus: 0)).to(equal(audioFile.processingFormat))
            }

            it("correctly sets up the player") {
                expect(player.outputFormat(forBus: 0)).to(equal(audioFile.processingFormat))
                expect(engine.outputNode.inputFormat(forBus: 0)).to(equal(audioFile.processingFormat))
            }

            it("does not start the engine") {
                expect(engine.isRunning).to(beFalsy())
            }

            it("stores off the file") {
                expect(audioBox.file).to(beIdenticalTo(audioFile))
            }

            it("sets up an engine with 5 delays, pitch shift, reverb and eq attached to a player") {
                let outputConnectionPoint = engine.inputConnectionPoint(for: engine.outputNode, inputBus: 0)!
                expect(outputConnectionPoint.node!).to(beAKindOf(AVAudioUnitDelay.self))

                let delay1 = outputConnectionPoint.node! as! AVAudioUnitDelay
                expect(delayNodes).to(contain(delay1))
                let delay1Connection = engine.inputConnectionPoint(for: delay1, inputBus: 0)!
                expect(delay1Connection.node!).to(beAKindOf(AVAudioUnitDelay.self))

                let delay2 = delay1Connection.node! as! AVAudioUnitDelay
                expect(delayNodes).to(contain(delay2))
                let delay2Connection = engine.inputConnectionPoint(for: delay2, inputBus: 0)!
                expect(delay2Connection.node!).to(beAKindOf(AVAudioUnitDelay.self))

                let delay3 = delay2Connection.node! as! AVAudioUnitDelay
                expect(delayNodes).to(contain(delay3))
                let delay3Connection = engine.inputConnectionPoint(for: delay3, inputBus: 0)!
                expect(delay3Connection.node!).to(beAKindOf(AVAudioUnitDelay.self))

                let delay4 = delay3Connection.node! as! AVAudioUnitDelay
                expect(delayNodes).to(contain(delay4))
                let delay4Connection = engine.inputConnectionPoint(for: delay4, inputBus: 0)!
                expect(delay4Connection.node!).to(beAKindOf(AVAudioUnitDelay.self))

                let delay5 = delay4Connection.node! as! AVAudioUnitDelay
                expect(delayNodes).to(contain(delay5))
                let delay5Connection = engine.inputConnectionPoint(for: delay5, inputBus: 0)!
                expect(delay5Connection.node!).to(beAKindOf(AVAudioUnitReverb.self))

                let reverbNode = delay5Connection.node! as! AVAudioUnitReverb
                expect(reverbNode).to(beIdenticalTo(reverb))
                let reverbConnection = engine.inputConnectionPoint(for: reverbNode, inputBus: 0)!
                expect(reverbConnection.node!).to(beAKindOf(AVAudioUnitVarispeed.self))

                let pitchShiftNode = reverbConnection.node! as! AVAudioUnitVarispeed
                expect(pitchShiftNode).to(beIdenticalTo(pitchShift))
                let pitchShiftConnection = engine.inputConnectionPoint(for: pitchShiftNode, inputBus: 0)!
                expect(pitchShiftConnection.node!).to(beAKindOf(AVAudioUnitEQ.self))

                let eqNode = pitchShiftConnection.node! as! AVAudioUnitEQ
                expect(eqNode).to(beIdenticalTo(eq))
                let eqConnection = engine.inputConnectionPoint(for: eqNode, inputBus: 0)!
                expect(eqConnection.node!).to(beAKindOf(AVAudioPlayerNode.self))

                let playerNode = eqConnection.node! as! AVAudioPlayerNode
                expect(playerNode).to(beIdenticalTo(player))
            }
        }

    }
}
