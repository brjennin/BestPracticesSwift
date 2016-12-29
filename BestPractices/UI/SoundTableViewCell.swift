import UIKit

class SoundTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "SoundTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureWithSound(sound: Sound) {
        self.titleLabel.text = sound.name
    }
    
}
