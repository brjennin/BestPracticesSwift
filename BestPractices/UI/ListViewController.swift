import UIKit

class ListViewController: UITableViewController {

    var dispatcher: DispatcherProtocol! = Dispatcher()
    var soundCache: SoundCacheProtocol! = SoundCache()
    weak var soundSelectionDelegate: SoundSelectionDelegate!

    var sounds: [Sound] = []

    var soundsCompletion: (([Sound]) -> ())!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "YACHTY"

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(refresh(refreshControl:)), for: .valueChanged)

        self.refreshControl!.beginRefreshing()

        soundsCompletion = { [weak self] sounds in
            if self != nil {
                self!.sounds = sounds
            }
            self?.dispatcher.dispatchToMainQueue {
                self?.tableView.reloadData()
                self?.refreshControl!.endRefreshing()
            }
        }

        self.soundCache.getSounds(completion: soundsCompletion)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sounds.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SoundTableViewCell.cellIdentifier, for: indexPath) as! SoundTableViewCell
        cell.configureWithSound(sound: self.sounds[(indexPath as NSIndexPath).row])

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.soundSelectionDelegate.soundWasSelected(sound: self.sounds[(indexPath as NSIndexPath).row])
    }

    func refresh(refreshControl: UIRefreshControl) {
        self.soundCache.getSoundsAndRefreshCache(completion: soundsCompletion)
    }
}
