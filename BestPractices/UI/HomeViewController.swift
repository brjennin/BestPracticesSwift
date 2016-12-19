import UIKit
import MediaPlayer

class HomeViewController: UIViewController {

    @IBOutlet weak var looseButton: UIButton!
    @IBOutlet weak var currentSoundLabel: UILabel!
    @IBOutlet weak var albumArtImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var delaySwitch: UISwitch!
    @IBOutlet weak var whammySlider: UISlider!
    @IBOutlet weak var reverbNation: UISwitch!

    var player: PlayerProtocol! = Player()
    var soundLoader: SoundLoaderProtocol! = SoundLoader()
    var soundCache: SoundCacheProtocol! = SoundCache()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "YACHTY"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.currentSoundLabel.text = ""
        soundCache.getSounds { [weak self] soundGroups in
            if soundGroups.count > 0 {
                self?.soundWasSelected(sound: soundGroups.first!.sounds.first!)
            }
        }

//        let sharedCenter = MPRemoteCommandCenter.shared()
//        sharedCenter.playCommand.isEnabled = true
//        sharedCenter.playCommand.addTarget { [weak self] event -> MPRemoteCommandHandlerStatus in
//            self?.play()
//            return MPRemoteCommandHandlerStatus.success
//        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToListView" {
            if let listViewController = segue.destination as? ListViewController {
                listViewController.soundSelectionDelegate = self
            }
        }
    }

    @IBAction func didWhammy(_ sender: UISlider) {
        player.pitchShift(amount: sender.value)
    }

    @IBAction func didReleaseWhammy(_ sender: UISlider) {
        sender.value = 0
        player.pitchShift(amount: sender.value)
    }

    @IBAction func didTapPlay(_ sender: UIButton) {
        self.play()
    }

    fileprivate func play() {
        self.player.play(delay: delaySwitch.isOn, reverb: reverbNation.isOn)
    }
}

extension HomeViewController: SoundSelectionDelegate {

    func soundWasSelected(sound: Sound) {
        _ = self.navigationController?.popViewController(animated: true)
        self.albumArtImageView.image = nil
        self.player.clearSound()
        self.currentSoundLabel.text = sound.name

        self.soundLoader.loadSoundAssets(sound: sound, soundCompletion: { [weak self] soundWithSound in
            if let soundPath = soundWithSound.soundLocalPath {
                self?.player.loadSound(filePath: soundPath)
            }
        }, imageCompletion: { [weak self] soundWithImage in
            if let imagePath = soundWithImage.imageLocalPath {
                let image = UIImage(contentsOfFile: imagePath)
                if let image = image {
                    self?.albumArtImageView.image = image
                    //                    let artwork = MPMediaItemArtwork(image: image)
                    //                    MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle: song.name, MPMediaItemPropertyArtist: song.artist, MPMediaItemPropertyArtwork: artwork]
                }
            }
        })
    }

}
