import AVKit
import AVFoundation

protocol PlayerProtocol: class {
    func loadSong(filePath: String)
    
    func clearSong()
    
    func play()
}

class Player: PlayerProtocol {
    
    var audioPlayer: AVAudioPlayer?
    
    func loadSong(filePath: String) {
        let url = NSURL(fileURLWithPath: filePath)
        self.audioPlayer = try? AVAudioPlayer(contentsOfURL: url)
    }
    
    func clearSong() {
        self.audioPlayer = nil
    }
    
    func play() {
        if let player = self.audioPlayer {
            player.play()
        }
    }
    
}
