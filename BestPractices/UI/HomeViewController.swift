import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var looseButton: UIButton!
    @IBOutlet weak var currentSongLabel: UILabel!
    @IBOutlet weak var albumArtImageView: UIImageView!

    var imageService: ImageServiceProtocol! = ImageService()

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToListView" {
            if let listViewController = segue.destinationViewController as? ListViewController {
                listViewController.songSelectionDelegate = self
            }
        }
    }
}

extension HomeViewController: SongSelectionDelegate {

    func songWasSelected(song: Song) {
        self.navigationController?.popViewControllerAnimated(true)
        self.currentSongLabel.text = song.name

        self.imageService.getImage(song.albumArt) { image in
            if let albumArt = image {
                self.albumArtImageView.image = albumArt
            }
        }
    }

}
