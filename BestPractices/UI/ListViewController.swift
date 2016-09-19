import UIKit

class ListViewController: UITableViewController {

    var songService: SongServiceProtocol! = SongService()
    var dispatcher: DispatcherProtocol! = Dispatcher()
    var songSelectionDelegate: SongSelectionDelegate!
    var songs: [Song] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.songService.getSongs({ songs in
            self.songs = songs
            self.dispatcher.dispatchToMainQueue({
                self.tableView.reloadData()
            })
        })
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
    
}
