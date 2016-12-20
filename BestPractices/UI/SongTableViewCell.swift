import UIKit

class SongTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "SongTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureWithSound(sound: Song) {
        self.titleLabel.text = sound.name
    }
    
}
