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
            var pitchShift: AVAudioUnitVarispeed!
            
            beforeEach {
                var littleEngine: AudioEngineProtocol
                var littlePlayer: AudioPlayerNodeProtocol
                var littleDelayNodes: [AudioDelayNodeProtocol]
                var littlePitchShift: AVAudioUnitVarispeed
                (littlePlayer, littleEngine, littleDelayNodes, littlePitchShift) = subject.buildEngine(audioFile: audioFile)
                player = littlePlayer as! AVAudioPlayerNode
                engine = littleEngine as! AVAudioEngine
                delayNodes = littleDelayNodes as! [AVAudioUnitDelay]
                pitchShift = littlePitchShift
            }

            it("sets up an engine with 5 delays attached to a player") {
                let outputConnectionPoint = engine.inputConnectionPoint(for: engine.outputNode, inputBus: 0)!
                expect(outputConnectionPoint.node!).to(beAKindOf(AVAudioUnitDelay.self))

                let delay1 = outputConnectionPoint.node! as! AVAudioUnitDelay
                expect(delayNodes).to(contain(delay1))
                expect(delay1.delayTime).to(equal(2))
                expect(delay1.feedback).to(equal(0))
                expect(delay1.wetDryMix).to(equal(100))
                expect(delay1.lowPassCutoff).to(equal(20000))
                expect(delay1.outputFormat(forBus: 0)).to(equal(audioFile.processingFormat))
                let delay1Connection = engine.inputConnectionPoint(for: delay1, inputBus: 0)!
                expect(delay1Connection.node!).to(beAKindOf(AVAudioUnitDelay.self))

                let delay2 = delay1Connection.node! as! AVAudioUnitDelay
                expect(delayNodes).to(contain(delay2))
                expect(delay2.delayTime).to(equal(2))
                expect(delay2.feedback).to(equal(0))
                expect(delay2.wetDryMix).to(equal(100))
                expect(delay2.lowPassCutoff).to(equal(20000))
                expect(delay2.outputFormat(forBus: 0)).to(equal(audioFile.processingFormat))
                let delay2Connection = engine.inputConnectionPoint(for: delay2, inputBus: 0)!
                expect(delay2Connection.node!).to(beAKindOf(AVAudioUnitDelay.self))

                let delay3 = delay2Connection.node! as! AVAudioUnitDelay
                expect(delayNodes).to(contain(delay3))
                expect(delay3.delayTime).to(equal(2))
                expect(delay3.feedback).to(equal(0))
                expect(delay3.wetDryMix).to(equal(100))
                expect(delay3.lowPassCutoff).to(equal(20000))
                expect(delay3.outputFormat(forBus: 0)).to(equal(audioFile.processingFormat))
                let delay3Connection = engine.inputConnectionPoint(for: delay3, inputBus: 0)!
                expect(delay3Connection.node!).to(beAKindOf(AVAudioUnitDelay.self))

                let delay4 = delay3Connection.node! as! AVAudioUnitDelay
                expect(delayNodes).to(contain(delay4))
                expect(delay4.delayTime).to(equal(2))
                expect(delay4.feedback).to(equal(0))
                expect(delay4.wetDryMix).to(equal(100))
                expect(delay4.lowPassCutoff).to(equal(20000))
                expect(delay4.outputFormat(forBus: 0)).to(equal(audioFile.processingFormat))
                let delay4Connection = engine.inputConnectionPoint(for: delay4, inputBus: 0)!
                expect(delay4Connection.node!).to(beAKindOf(AVAudioUnitDelay.self))

                let delay5 = delay4Connection.node! as! AVAudioUnitDelay
                expect(delayNodes).to(contain(delay5))
                expect(delay5.delayTime).to(equal(2))
                expect(delay5.feedback).to(equal(0))
                expect(delay5.wetDryMix).to(equal(100))
                expect(delay5.lowPassCutoff).to(equal(20000))
                expect(delay5.outputFormat(forBus: 0)).to(equal(audioFile.processingFormat))
                let delay5Connection = engine.inputConnectionPoint(for: delay5, inputBus: 0)!
                expect(delay5Connection.node!).to(beAKindOf(AVAudioUnitVarispeed.self))
                expect(delay5Connection.node!).to(beIdenticalTo(pitchShift))
                
                let pitchShiftNode = delay5Connection.node! as! AVAudioUnitVarispeed
                expect(pitchShiftNode.rate).to(equal(1))
                expect(pitchShiftNode.outputFormat(forBus: 0)).to(equal(audioFile.processingFormat))
                let pitchShiftConnection = engine.inputConnectionPoint(for: pitchShiftNode, inputBus: 0)!
                expect(pitchShiftConnection.node!).to(beAKindOf(AVAudioPlayerNode.self))
                expect(pitchShiftConnection.node!).to(beIdenticalTo(player))
                
                let playerNode = pitchShiftConnection.node! as! AVAudioPlayerNode
                expect(playerNode.outputFormat(forBus: 0)).to(equal(audioFile.processingFormat))

                expect(engine.outputNode.inputFormat(forBus: 0)).to(equal(audioFile.processingFormat))

                expect(delayNodes.count).to(equal(5))
            }

            it("does not start the engine") {
                expect(engine.isRunning).to(beFalsy())
            }
        }

    }
}



