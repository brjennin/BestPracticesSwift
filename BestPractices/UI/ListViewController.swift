import UIKit

class ListViewController: UITableViewController {

    var dispatcher: DispatcherProtocol! = Dispatcher()
    var soundCache: SoundCacheProtocol! = SoundCache()
    weak var soundSelectionDelegate: SoundSelectionDelegate!

    var soundGroups: [SoundGroup] = []

    var soundsCompletion: (([SoundGroup]) -> ())!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Choose a Sound"

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(refresh(refreshControl:)), for: .valueChanged)

        self.refreshControl!.beginRefreshing()

        soundsCompletion = { [weak self] soundGroups in
            if self != nil {
                self!.soundGroups = soundGroups
            }
            self?.dispatcher.dispatchToMainQueue {
                self?.tableView.reloadData()
                self?.refreshControl!.endRefreshing()
            }
        }

        self.soundCache.getSounds(completion: soundsCompletion)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.soundGroups.count + 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }

        let view = tableView.dequeueReusableCell(withIdentifier: SectionHeaderViewCell.cellIdentifier) as! SectionHeaderViewCell
        view.configureWithTitle(title: self.soundGroups[section-1].name)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 30
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : self.soundGroups[section-1].sounds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PullToRefreshTableViewCell.cellIdentifier, for: indexPath)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SoundTableViewCell.cellIdentifier, for: indexPath) as! SoundTableViewCell
            cell.configureWithSound(sound: self.soundGroups[indexPath.section-1].sounds[indexPath.row])
            
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            self.soundSelectionDelegate.soundWasSelected(sound: self.soundGroups[indexPath.section-1].sounds[indexPath.row])
        }
    }

    func refresh(refreshControl: UIRefreshControl) {
        self.soundCache.getSoundsAndRefreshCache(completion: soundsCompletion)
    }
}
