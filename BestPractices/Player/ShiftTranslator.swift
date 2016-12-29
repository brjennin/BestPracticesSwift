import Foundation

protocol ShiftTranslatorProtocol: class {
    func translateSlider(value: Float) -> Float
}

class ShiftTranslator: ShiftTranslatorProtocol {
    func translateSlider(value: Float) -> Float {
        return pow(2, value)
    }
}
