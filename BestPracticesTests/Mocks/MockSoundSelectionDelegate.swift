@testable import BestPractices

class MockSoundSelectionDelegate: SoundSelectionDelegate {
    var calledDelegate = false
    var capturedSound: Sound?
    
    func soundWasSelected(sound: Sound) {
        self.calledDelegate = true
        self.capturedSound = sound
    }
}
