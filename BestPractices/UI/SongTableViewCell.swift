import UIKit

class SongTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "SongTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureWithSong(song: Song) {
        self.titleLabel.text = song.name
    }
    
}
