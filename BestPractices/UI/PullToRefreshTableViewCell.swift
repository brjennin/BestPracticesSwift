import UIKit
import Font_Awesome_Swift

class PullToRefreshTableViewCell: UITableViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    
    static let cellIdentifier = "PullToRefreshTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.infoLabel.setFAText(prefixText: "Pull to Refresh  ", icon: FAType.FARefresh, postfixText: "", size: 14.0, iconSize: 14.0)
    }

}
