import UIKit

class SongTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "SongTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureWithSound(sound: Sound) {
        self.titleLabel.text = sound.name
    }
    
}
