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
    var songLoader: SongLoaderProtocol! = SongLoader()
    var soundCache: SoundCacheProtocol! = SoundCache()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "YACHTY"
        self.currentSongLabel.text = ""
        soundCache.getSongs { [weak self] songs in
            if songs.count > 0 {
                self?.songWasSelected(song: songs.first!)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToListView" {
            if let listViewController = segue.destination as? ListViewController {
                listViewController.songSelectionDelegate = self
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

extension HomeViewController: SongSelectionDelegate {

    func songWasSelected(song: Song) {
        _ = self.navigationController?.popViewController(animated: true)
        self.albumArtImageView.image = nil
        self.player.clearSong()
        self.currentSongLabel.text = song.name

        self.songLoader.loadSongAssets(song: song, songCompletion: { [weak self] songWithSong in
            if let songPath = songWithSong.songLocalPath {
                self?.player.loadSong(filePath: songPath)
            }
        }, imageCompletion: { [weak self] songWithImage in
            if let imagePath = songWithImage.imageLocalPath {
                self?.albumArtImageView.image = UIImage(contentsOfFile: imagePath)
            }
        })
    }

}
