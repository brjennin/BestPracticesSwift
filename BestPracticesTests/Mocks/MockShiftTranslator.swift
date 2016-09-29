@testable import BestPractices

class MockShiftTranslator: ShiftTranslatorProtocol {
    var calledTranslate = false
    var capturedInputValue: Float?
    var returnValueForTranslation: Float!
    
    func translateSlider(value: Float) -> Float {
        calledTranslate = true
        capturedInputValue = value
        return returnValueForTranslation
    }
}
