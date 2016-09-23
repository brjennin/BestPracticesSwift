import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var looseButton: UIButton!
    @IBOutlet weak var currentSongLabel: UILabel!
    @IBOutlet weak var albumArtImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    
    var player: PlayerProtocol! = Player()
    var songLoader: SongLoaderProtocol! = SongLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "YACHTY"
        self.currentSongLabel.text = ""
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToListView" {
            if let listViewController = segue.destinationViewController as? ListViewController {
                listViewController.songSelectionDelegate = self
            }
        }
    }
    
    @IBAction func didTapPlay(sender: UIButton) {
        self.player.play()
    }
}

extension HomeViewController: SongSelectionDelegate {
    
    func songWasSelected(song: Song) {
        self.navigationController?.popViewControllerAnimated(true)
        self.albumArtImageView.image = nil
        self.player.clearSong()
        self.currentSongLabel.text = song.name
        
        self.songLoader.loadSongAssets(song, songCompletion: { songWithSong in
            if let songPath = songWithSong.songLocalPath {
                self.player.loadSong(songPath)
            }
        }, imageCompletion: { songWithImage in
            if let imagePath = songWithImage.imageLocalPath {
                self.albumArtImageView.image = UIImage(contentsOfFile: imagePath)
            }
        })
    }
    
}
