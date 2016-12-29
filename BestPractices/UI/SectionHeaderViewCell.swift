import UIKit

class SectionHeaderViewCell: UITableViewCell {
    
    static let cellIdentifier = "SectionHeaderViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureWithTitle(title: String) {
        self.titleLabel.text = title.uppercased()
    }
}
