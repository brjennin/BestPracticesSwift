import UIKit

class ListViewController: UITableViewController {

    var dispatcher: DispatcherProtocol! = Dispatcher()
    var songCache: SongCacheProtocol! = SongCache()
    var songSelectionDelegate: SongSelectionDelegate!

    var songs: [Song] = []

    var songsCompletion: ([Song] -> ())!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "YACHTY"

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(refresh(_:)), forControlEvents: .ValueChanged)

        self.refreshControl!.beginRefreshing()

        songsCompletion = { [weak self] songs in
            if self != nil {
                self!.songs = songs
            }
            self?.dispatcher.dispatchToMainQueue({
                self?.tableView.reloadData()
                self?.refreshControl!.endRefreshing()
            })
        }

        self.songCache.getSongs(songsCompletion)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SongTableViewCell.cellIdentifier, forIndexPath: indexPath) as! SongTableViewCell
        cell.configureWithSong(self.songs[indexPath.row])

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.songSelectionDelegate.songWasSelected(self.songs[indexPath.row])
    }

    func refresh(refreshControl: UIRefreshControl) {
        self.songCache.getSongsAndRefreshCache(songsCompletion)
    }
}
