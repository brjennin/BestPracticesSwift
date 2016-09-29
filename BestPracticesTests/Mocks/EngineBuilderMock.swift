import AVKit
import AVFoundation
@testable import BestPractices

class MockEngineBuilder: EngineBuilderProtocol {

    var calledBuildEngine = false
    var capturedAudioFile: AVAudioFile?
    var returnPlayerValueForBuildEngine: AudioPlayerNodeProtocol!
    var returnEngineValueForBuildEngine: AudioEngineProtocol!
    var returnDelaysValueForBuildEngine: [AudioDelayNodeProtocol]!
    var returnShiftNodeValueForBuildEngine: AVAudioUnitVarispeed!
    
    func buildEngine(audioFile: AVAudioFile) -> (AudioPlayerNodeProtocol, AudioEngineProtocol, [AudioDelayNodeProtocol], AVAudioUnitVarispeed) {
        capturedAudioFile = audioFile
        calledBuildEngine = true
        return (returnPlayerValueForBuildEngine, returnEngineValueForBuildEngine, returnDelaysValueForBuildEngine, returnShiftNodeValueForBuildEngine)
    }
}
