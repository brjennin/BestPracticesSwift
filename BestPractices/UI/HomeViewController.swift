import UIKit
import Font_Awesome_Swift

class HomeViewController: UIViewController {

    @IBOutlet weak var albumArtImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var delaySwitch: UISwitch!
    @IBOutlet weak var whammySlider: UISlider!
    @IBOutlet weak var reverbNation: UISwitch!
    @IBOutlet weak var chooseSoundButton: UIBarButtonItem!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet var smallRadiusElements: [UIView]!
    @IBOutlet var largeRadiusElements: [UIView]!
    @IBOutlet var circleRadiusElements: [UIView]!
    
    var player: PlayerProtocol! = Player()
    var soundLoader: SoundLoaderProtocol! = SoundLoader()
    var soundCache: SoundCacheProtocol! = SoundCache()
    var diskMaster: DiskMasterProtocol! = DiskMaster()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = AppDelegate.applicationName
        self.playButton.setFAIcon(icon: FAType.FAPhone, iconSize: 50, forState: .normal)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.chooseSoundButton.FAIcon = FAType.FAUserPlus
        self.nameLabel.text = ""
        
        soundCache.getSounds { [weak self] soundGroups in
            if soundGroups.count > 0 {
                self?.soundWasSelected(sound: soundGroups.first!.sounds.first!)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for element in smallRadiusElements {
            element.layer.cornerRadius = 1
            element.layer.masksToBounds = true
        }
        for element in largeRadiusElements {
            element.layer.cornerRadius = 5
            element.layer.masksToBounds = true
        }
        for element in circleRadiusElements {
            element.layer.cornerRadius = element.bounds.width / 2.0
            element.layer.masksToBounds = true
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
        self.nameLabel.text = sound.name

        self.soundLoader.loadSoundAssets(sound: sound, soundCompletion: { [weak self] soundWithSound in
            if let soundPath = soundWithSound.soundLocalPath {
                let fullURL = self?.diskMaster.mediaURLForFileWithFilename(filepath: soundPath)
                if let fullURL = fullURL {
                    self?.player.loadSound(filePath: fullURL.path)
                }
            }
        }, imageCompletion: { [weak self] soundWithImage in
            if let imagePath = soundWithImage.imageLocalPath {
                let fullURL = self?.diskMaster.mediaURLForFileWithFilename(filepath: imagePath)
                if let fullURL = fullURL {
                    self?.albumArtImageView.image = UIImage(contentsOfFile: fullURL.path)
                }
            }
        })
    }

}
