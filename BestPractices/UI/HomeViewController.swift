import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var looseButton: UIButton!
    @IBOutlet weak var currentSongLabel: UILabel!
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
        self.currentSongLabel.text = ""
        soundCache.getSounds { [weak self] sounds in
            if sounds.count > 0 {
                self?.soundWasSelected(sound: sounds.first!)
            }
        }
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
        self.player.play(delay: delaySwitch.isOn, reverb: reverbNation.isOn)
    }
}

extension HomeViewController: SoundSelectionDelegate {

    func soundWasSelected(sound: Sound) {
        _ = self.navigationController?.popViewController(animated: true)
        self.albumArtImageView.image = nil
        self.player.clearSound()
        self.currentSongLabel.text = sound.name

        self.soundLoader.loadSoundAssets(sound: sound, soundCompletion: { [weak self] soundWithSound in
            if let soundPath = soundWithSound.soundLocalPath {
                self?.player.loadSound(filePath: soundPath)
            }
        }, imageCompletion: { [weak self] soundWithImage in
            if let imagePath = soundWithImage.imageLocalPath {
                self?.albumArtImageView.image = UIImage(contentsOfFile: imagePath)
            }
        })
    }

}
