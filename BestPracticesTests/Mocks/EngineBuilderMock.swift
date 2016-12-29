import AVKit
import AVFoundation
@testable import BestPractices

class MockEngineBuilder: EngineBuilderProtocol {

    var calledBuildEngine = false
    var capturedAudioFile: AVAudioFile?
    var returnAudioBoxValueForBuildEngine: AudioBoxProtocol!

    func buildEngine(audioFile: AVAudioFile) -> (AudioBoxProtocol) {
        capturedAudioFile = audioFile
        calledBuildEngine = true
        return returnAudioBoxValueForBuildEngine
    }
}
