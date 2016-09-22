import UIKit

class ListViewController: UITableViewController {

    var dispatcher: DispatcherProtocol! = Dispatcher()
    var songCache: SongCacheProtocol! = SongCache()
    var songSelectionDelegate: SongSelectionDelegate!
    
    var songs: [Song] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "YACHTY"
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(refresh(_:)), forControlEvents: .ValueChanged)

        self.songCache.getSongs { songs in
            self.songs = songs
            self.dispatcher.dispatchToMainQueue({
                self.tableView.reloadData()
            })
        }
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
        fetchSongs()
    }
    
    private func fetchSongs() {
        self.songCache.getSongsAndRefreshCache { songs in
            self.songs = songs
            self.dispatcher.dispatchToMainQueue {
                self.tableView.reloadData()
                self.refreshControl!.endRefreshing()
            }
        }
    }
}
