import AVKit
import AVFoundation
@testable import BestPractices

class MockAVAudioPlayerNode: AudioPlayerNodeProtocol {
    var calledScheduleFile = false
    var capturedFile: AVAudioFile?
    
    func scheduleFile(_ file: AVAudioFile, at when: AVAudioTime?, completionHandler: AVFoundation.AVAudioNodeCompletionHandler?) {
        calledScheduleFile = true
        capturedFile = file
    }
    
    var calledStop = false
    
    func stop() {
        calledStop = true
    }
    
    var calledPlay = false
    
    func play() {
        calledPlay = true
    }
}
