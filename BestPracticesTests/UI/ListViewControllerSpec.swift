import Quick
import Nimble
@testable import BestPractices

class ListViewControllerSpec: QuickSpec {

    override func spec() {

        var subject: ListViewController!
        var dispatcher: MockDispatcher!
        var soundSelectionDelegate: MockSoundSelectionDelegate!
        var soundCache: MockSoundCache!

        beforeEach {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            subject = storyboard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController

            dispatcher = MockDispatcher()
            subject.dispatcher = dispatcher

            soundSelectionDelegate = MockSoundSelectionDelegate()
            subject.soundSelectionDelegate = soundSelectionDelegate

            soundCache = MockSoundCache()
            subject.soundCache = soundCache
        }

        sharedExamples("reloading songs") {
            it("should dispatch to the main queue") {
                expect(dispatcher.calledDispatch).to(beTruthy())
            }

            it("has 2 song table view cells correctly configured") {
                expect(subject.tableView.visibleCells.count).to(equal(2))
                expect(subject.tableView.visibleCells.first).to(beAKindOf(SongTableViewCell.self))
                expect(subject.tableView.visibleCells.last).to(beAKindOf(SongTableViewCell.self))

                let cellOne = subject.tableView.visibleCells.first as! SongTableViewCell
                let cellTwo = subject.tableView.visibleCells.last as! SongTableViewCell
                expect(cellOne.titleLabel.text).to(equal("Song One"))
                expect(cellTwo.titleLabel.text).to(equal("Song Two"))
            }

            it("should end refreshing") {
                expect(subject.refreshControl!.isRefreshing).to(beFalsy())
            }

            describe("As a UITableViewDataSource") {
                describe(".numberOfSectionsInTableView") {
                    it("should have 1 section") {
                        expect(subject.numberOfSections(in: subject.tableView)).to(equal(1))
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
                    let indexPath = IndexPath(row: 0, section: 0)
                    subject.tableView(subject.tableView, didSelectRowAt: indexPath)
                }

                it("calls the delegate with the correct song") {
                    expect(soundSelectionDelegate.calledDelegate).to(beTruthy())
                    expect(soundSelectionDelegate.capturedSound).toNot(beNil())
                    expect(soundSelectionDelegate.capturedSound!.identifier).to(equal(123))
                }
            }
        }

        describe(".viewDidLoad") {
            let songOne = Song(value: ["identifier": 123, "name": "Song One"])
            let songTwo = Song(value: ["identifier": 111, "name": "Song Two"])
            let songs = [songOne, songTwo]

            beforeEach {
                UIApplication.shared.keyWindow?.rootViewController = subject
            }

            it("gets the songs from the cache") {
                expect(soundCache.calledGetSounds).to(beTruthy())
            }

            it("sets the title") {
                expect(subject.title).to(equal("YACHTY"))
            }

            it("sets itself as the data source for the table view") {
                expect(subject.tableView.dataSource).to(beIdenticalTo(subject))
            }

            it("sets itself as the delegate for the table view") {
                expect(subject.tableView.delegate).to(beIdenticalTo(subject))
            }

            it("sets up a refresh control") {
                expect(subject.refreshControl!).toNot(beNil())
                expect(subject.tableView.subviews).to(contain(subject.refreshControl!))
            }

            it("starts the spinner on the refresh control") {
                expect(subject.refreshControl!.isRefreshing).to(beTruthy())
            }

            describe("As a UITableViewDataSource") {
                describe(".numberOfSectionsInTableView") {
                    it("should have 1 section") {
                        expect(subject.numberOfSections(in: subject.tableView)).to(equal(1))
                    }
                }

                describe(".tableView:numberOfRowsInSection:") {
                    it("should start with 0 rows in the first section") {
                        expect(subject.tableView(subject.tableView, numberOfRowsInSection: 0)).to(equal(0))
                    }
                }
            }

            describe("When the cache resolves with songs") {
                beforeEach {
                    soundCache.capturedGetSoundsCompletion!(songs)
                }

                itBehavesLike("reloading songs")
            }

            describe("Pulling to refresh") {
                beforeEach {
                    subject.refreshControl!.sendActions(for: .valueChanged)
                    subject.refreshControl!.beginRefreshing()
                }

                it("gets the songs from the cache and refreashes the cache") {
                    expect(soundCache.calledGetSoundsAndRefreshCache).to(beTruthy())
                }

                describe("When the cache resolves with songs") {
                    beforeEach {
                        soundCache.capturedGetSoundsAndRefreshCacheCompletion!(songs)
                    }

                    itBehavesLike("reloading songs")
                }
            }
        }

    }
}
