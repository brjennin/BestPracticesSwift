import AVKit
import AVFoundation

protocol PlayerProtocol: class {
    func loadSong(song: Song)
    
    func play()
}

class Player: PlayerProtocol {
    
    var httpClient: HTTPClientProtocol! = HTTPClient()
    var audioPlayer: AVAudioPlayer?
    
    func loadSong(song: Song) {
        self.httpClient.downloadFile(song.url, folderPath: "songs/\(song.identifier)/") { url in
            if let url = url {
                self.audioPlayer = try? AVAudioPlayer(contentsOfURL: url)
            }
        }
    }
    
    func play() {
        if let player = self.audioPlayer {
            player.play()
        }
    }
    
}
