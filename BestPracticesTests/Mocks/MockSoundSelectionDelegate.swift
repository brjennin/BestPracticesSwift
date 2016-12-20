@testable import BestPractices

class MockSoundSelectionDelegate: SoundSelectionDelegate {
    var calledDelegate = false
    var capturedSound: Song?
    
    func soundWasSelected(sound: Song) {
        self.calledDelegate = true
        self.capturedSound = sound
    }
}
