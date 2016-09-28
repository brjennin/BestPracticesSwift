import UIKit

class ListViewController: UITableViewController {

    var dispatcher: DispatcherProtocol! = Dispatcher()
    var songCache: SongCacheProtocol! = SongCache()
    var songSelectionDelegate: SongSelectionDelegate!

    var songs: [Song] = []

    var songsCompletion: (([Song]) -> ())!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "YACHTY"

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(refresh(refreshControl:)), for: .valueChanged)

        self.refreshControl!.beginRefreshing()

        songsCompletion = { [weak self] songs in
            if self != nil {
                self!.songs = songs
            }
            self?.dispatcher.dispatchToMainQueue {
                self?.tableView.reloadData()
                self?.refreshControl!.endRefreshing()
            }
        }

        self.songCache.getSongs(completion: songsCompletion)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.cellIdentifier, for: indexPath) as! SongTableViewCell
        cell.configureWithSong(song: self.songs[(indexPath as NSIndexPath).row])

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.songSelectionDelegate.songWasSelected(song: self.songs[(indexPath as NSIndexPath).row])
    }

    func refresh(refreshControl: UIRefreshControl) {
        self.songCache.getSongsAndRefreshCache(completion: songsCompletion)
    }
}
