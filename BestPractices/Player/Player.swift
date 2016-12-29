import AVKit
import AVFoundation

protocol PlayerProtocol: class {
    func loadSound(filePath: String)

    func clearSound()

    func play(delay: Bool, reverb: Bool)

    func pitchShift(amount: Float)
}

class Player: PlayerProtocol {

    var engineBuilder: EngineBuilderProtocol! = EngineBuilder()
    var shiftTranslator: ShiftTranslatorProtocol! = ShiftTranslator()

    var audioBox: AudioBoxProtocol?

    func loadSound(filePath: String) {
        let url = URL(fileURLWithPath: filePath)
        let file = try? AVAudioFile.init(forReading: url)

        if let file = file {
            do {
                audioBox = engineBuilder.buildEngine(audioFile: file)
                try audioBox!.start()
            } catch {
                audioBox = nil
            }
        }
    }

    func clearSound() {
        audioBox?.stop()
        audioBox = nil
    }

    func play(delay: Bool, reverb: Bool) {
        audioBox?.play(delay: delay, reverb: reverb)
    }

    func pitchShift(amount: Float) {
        audioBox?.pitchShift(amount: shiftTranslator.translateSlider(value: amount))
    }

}
