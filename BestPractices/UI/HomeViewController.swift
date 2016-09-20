import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var looseButton: UIButton!
    @IBOutlet weak var currentSongLabel: UILabel!
    @IBOutlet weak var albumArtImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!

    var imageService: ImageServiceProtocol! = ImageService()
    var player: PlayerProtocol! = Player()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "YACHTY"
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
        self.currentSongLabel.text = song.name
        self.player.loadSong(song)
        
        self.imageService.getImage(song.albumArt) { image in
            if let albumArt = image {
                self.albumArtImageView.image = albumArt
            }
        }
    }

}
