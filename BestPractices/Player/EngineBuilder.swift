import AVKit
import AVFoundation

protocol EngineBuilderProtocol: class {
    func buildEngine(audioFile: AVAudioFile) -> (AudioBoxProtocol)
}

class EngineBuilder: EngineBuilderProtocol {

    func buildEngine(audioFile: AVAudioFile) -> (AudioBoxProtocol) {
        let engine = AVAudioEngine()
        let playerNode = AVAudioPlayerNode()
        let pitchShiftNode = AVAudioUnitVarispeed()
        let reverbNode = AVAudioUnitReverb()
        reverbNode.wetDryMix = 0
        reverbNode.loadFactoryPreset(AVAudioUnitReverbPreset.cathedral)
        let delayNodes = [AVAudioUnitDelay(), AVAudioUnitDelay(), AVAudioUnitDelay(), AVAudioUnitDelay(), AVAudioUnitDelay()]
        let eqNode = AVAudioUnitEQ()
        var nodes: [AVAudioNode] = [playerNode]
        nodes.append(eqNode)
        nodes.append(reverbNode)
        for node in delayNodes {
            nodes.append(node)
        }
        nodes.append(pitchShiftNode)

        var previousNode: AVAudioNode?
        for node in nodes {
            engine.attach(node)
            if let previousNode = previousNode {
               engine.connect(previousNode, to: node, format: audioFile.processingFormat)
            }
            if node.isKind(of: AVAudioUnitDelay.self) {
                let delayNode = node as! AVAudioUnitDelay
                delayNode.feedback = 0
                delayNode.delayTime = 2
                delayNode.wetDryMix = 100
                delayNode.lowPassCutoff = 20000
            }
            previousNode = node
        }
        engine.connect(nodes.last!, to: engine.outputNode, format: audioFile.processingFormat)

        return AudioBox(file: audioFile, engine: engine, player: playerNode, pitchShift: pitchShiftNode, delays: delayNodes, reverb: reverbNode, eq: eqNode)
    }

}
