import Quick
import Nimble
import Fleet
@testable import BestPractices

class ListViewControllerSpec: QuickSpec {        
    
    override func spec() {
        
        var subject: ListViewController!
        var songService: MockSongService!
        var dispatcher: MockDispatcher!
        var songSelectionDelegate: MockSongSelectionDelegate!
        
        beforeEach {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            subject = storyboard.instantiateViewControllerWithIdentifier("ListViewController") as! ListViewController
            
            songService = MockSongService()
            subject.songService = songService
            
            dispatcher = MockDispatcher()
            subject.dispatcher = dispatcher
            
            songSelectionDelegate = MockSongSelectionDelegate()
            subject.songSelectionDelegate = songSelectionDelegate
        }
        
        describe(".viewDidLoad") {
            beforeEach {
                Fleet.setApplicationWindowRootViewController(subject)
            }
            
            it("sets itself as the data source for the table view") {
                expect(subject.tableView.dataSource).to(beIdenticalTo(subject))
            }
            
            it("sets itself as the delegate for the table view") {
                expect(subject.tableView.delegate).to(beIdenticalTo(subject))
            }
            
            it("calls the SongService") {
                expect(songService.calledService).to(beTruthy())
            }
            
            describe("As a UITableViewDataSource") {
                describe(".numberOfSectionsInTableView") {
                    it("should have 1 section") {
                        expect(subject.numberOfSectionsInTableView(subject.tableView)).to(equal(1))
                    }
                }
                
                describe(".tableView:numberOfRowsInSection:") {
                    it("should start with 0 rows in the first section") {
                        expect(subject.tableView(subject.tableView, numberOfRowsInSection: 0)).to(equal(0))
                    }
                }
            }
            
            describe("When the service returns") {
                beforeEach {
                    let songOne = Song(identifier: 123, name: "Song One", artist: "", url: "", albumArt: "")
                    let songTwo = Song(identifier: 111, name: "Song Two", artist: "", url: "", albumArt: "")
                    let songs = [songOne, songTwo]
                    
                    songService.completion(songs)
                }

                it("should dispatch to the main queue") {
                    expect(dispatcher.calledDispatch).to(beTruthy())
                }
                
                it("has 2 song table view cells correctly configured") {
                    expect(subject.tableView.visibleCells.count).to(equal(2))
                    expect(subject.tableView.visibleCells.first).to(beAKindOf(SongTableViewCell))
                    expect(subject.tableView.visibleCells.last).to(beAKindOf(SongTableViewCell))
                    
                    let cellOne = subject.tableView.visibleCells.first as! SongTableViewCell
                    let cellTwo = subject.tableView.visibleCells.last as! SongTableViewCell
                    expect(cellOne.titleLabel.text).to(equal("Song One"))
                    expect(cellTwo.titleLabel.text).to(equal("Song Two"))
                }
                
                describe("As a UITableViewDataSource") {
                    describe(".numberOfSectionsInTableView") {
                        it("should have 1 section") {
                            expect(subject.numberOfSectionsInTableView(subject.tableView)).to(equal(1))
                        }
                    }
                    
                    describe(".tableView:numberOfRowsInSection:") {
                        it("should have 2 rows in the first section") {
                            expect(subject.tableView(subject.tableView, numberOfRowsInSection: 0)).to(equal(2))
                        }                        
                    }
                }
                
                describe("Tapping on a cell") {
                    beforeEach {
                        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                        subject.tableView(subject.tableView, didSelectRowAtIndexPath: indexPath)
                    }
                    
                    it("calls the delegate with the correct song") {
                        expect(songSelectionDelegate.calledDelegate).to(beTruthy())
                        expect(songSelectionDelegate.capturedSong).toNot(beNil())
                        expect(songSelectionDelegate.capturedSong!.identifier).to(equal(123))
                    }
                }
            }
        }
        
    }
}
