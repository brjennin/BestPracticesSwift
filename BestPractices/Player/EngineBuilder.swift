import AVKit
import AVFoundation

protocol EngineBuilderProtocol: class {
    func buildEngine(audioFile: AVAudioFile) -> (AudioPlayerNodeProtocol, AudioEngineProtocol, [AudioDelayNodeProtocol], AVAudioUnitVarispeed)
}

class EngineBuilder: EngineBuilderProtocol {

    func buildEngine(audioFile: AVAudioFile) -> (AudioPlayerNodeProtocol, AudioEngineProtocol, [AudioDelayNodeProtocol], AVAudioUnitVarispeed) {
        let engine = AVAudioEngine()
        let playerNode = AVAudioPlayerNode()
        let pitchShiftNode = AVAudioUnitVarispeed()
        let delayNodes = [AVAudioUnitDelay(), AVAudioUnitDelay(), AVAudioUnitDelay(), AVAudioUnitDelay(), AVAudioUnitDelay()]
        var nodes: [AVAudioNode] = [playerNode]
        nodes.append(pitchShiftNode)
        for node in delayNodes {
            nodes.append(node)
        }

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

        return (playerNode, engine, delayNodes, pitchShiftNode)
    }

}
