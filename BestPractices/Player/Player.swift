import AVKit
import AVFoundation

protocol PlayerProtocol: class {
    func loadSong(filePath: String)

    func clearSong()

    func play(delay: Bool)
}

class Player: PlayerProtocol {

    var engineBuilder: EngineBuilderProtocol! = EngineBuilder()
    var playerNode: AudioPlayerNodeProtocol?
    var delayNodes: [AudioDelayNodeProtocol]?
    var engine: AudioEngineProtocol!

    func loadSong(filePath: String) {
        let url = URL(fileURLWithPath: filePath)
        let file = try? AVAudioFile.init(forReading: url)

        if let file = file {
            var audioPlayer: AudioPlayerNodeProtocol
            var audioEngine: AudioEngineProtocol
            var audioDelayNodes: [AudioDelayNodeProtocol]
            (audioPlayer, audioEngine, audioDelayNodes) = engineBuilder.buildEngine(audioFile: file)

            audioPlayer.scheduleFile(file, at: nil, completionHandler: nil)
            audioEngine.prepare()
            do {
                try audioEngine.start()
            } catch {
                return
            }

            playerNode = audioPlayer
            engine = audioEngine
            delayNodes = audioDelayNodes
        }
    }

    func clearSong() {
        if let playerNode = playerNode {
            playerNode.stop()
        }
        engine = nil
        playerNode = nil
        delayNodes = nil
    }

    func play(delay: Bool) {
        if let playerNode = playerNode {
            setDelayBypass(delayUnits: delayNodes!, bypass: !delay)
            playerNode.play()
        }
    }

    fileprivate func setDelayBypass(delayUnits: [AudioDelayNodeProtocol], bypass: Bool) {
        for unit in delayUnits {
            unit.bypass = bypass
        }
    }
}
