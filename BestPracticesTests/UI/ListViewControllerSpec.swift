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

        sharedExamples("reloading sounds") {
            it("should dispatch to the main queue") {
                expect(dispatcher.calledDispatch).to(beTruthy())
            }

            it("has 3 sound table view cells correctly configured and one refresh cell") {
                expect(subject.tableView.visibleCells.count).to(equal(4))
                expect(subject.tableView.visibleCells[0]).to(beAKindOf(PullToRefreshTableViewCell.self))
                expect(subject.tableView.visibleCells[1]).to(beAKindOf(SoundTableViewCell.self))
                expect(subject.tableView.visibleCells[2]).to(beAKindOf(SoundTableViewCell.self))
                expect(subject.tableView.visibleCells[3]).to(beAKindOf(SoundTableViewCell.self))
                
                let cellOne = subject.tableView.visibleCells[1] as! SoundTableViewCell
                let cellTwo = subject.tableView.visibleCells[2] as! SoundTableViewCell
                let cellThree = subject.tableView.visibleCells[3] as! SoundTableViewCell
                expect(cellOne.titleLabel.text).to(equal("Sound One"))
                expect(cellTwo.titleLabel.text).to(equal("Sound Two"))
                expect(cellThree.titleLabel.text).to(equal("Sound Three"))
            }

            it("should end refreshing") {
                expect(subject.refreshControl!.isRefreshing).to(beFalsy())
            }

            describe("As a UITableViewDataSource") {
                describe(".numberOfSectionsInTableView") {
                    it("should have 3 sections") {
                        expect(subject.numberOfSections(in: subject.tableView)).to(equal(3))
                    }
                }

                describe(".tableView:numberOfRowsInSection:") {
                    it("should have 1 row in the first section") {
                        expect(subject.tableView(subject.tableView, numberOfRowsInSection: 0)).to(equal(1))
                    }
                    
                    it("should have 2 rows in the second section") {
                        expect(subject.tableView(subject.tableView, numberOfRowsInSection: 1)).to(equal(2))
                    }
                    
                    it("should have 1 row in the third section") {
                        expect(subject.tableView(subject.tableView, numberOfRowsInSection: 2)).to(equal(1))
                    }
                }
                
                describe(".numberOfSectionsInTableView") {
                    it("should have 3 sections") {
                        expect(subject.numberOfSections(in: subject.tableView)).to(equal(3))
                    }
                }
                
                describe(".tableView:numberOfRowsInSection:") {
                    it("should start with 1 row in the first section, 2 rows in 2nd and 1 in 3rd") {
                        expect(subject.tableView(subject.tableView, numberOfRowsInSection: 0)).to(equal(1))
                        expect(subject.tableView(subject.tableView, numberOfRowsInSection: 1)).to(equal(2))
                        expect(subject.tableView(subject.tableView, numberOfRowsInSection: 2)).to(equal(1))
                    }
                }
                
                describe(".tableView:heightForHeaderInSection:") {
                    it("Sets the title for the table sections") {
                        expect(subject.tableView(subject.tableView, heightForHeaderInSection: 0)).to(equal(0))
                        expect(subject.tableView(subject.tableView, heightForHeaderInSection: 1)).to(equal(30))
                        expect(subject.tableView(subject.tableView, heightForHeaderInSection: 2)).to(equal(30))
                    }
                }
                
                describe(".tableView:viewForHeaderInSection:") {
                    it("Sets the title for the table sections") {
                        let sectionOne = subject.tableView(subject.tableView, viewForHeaderInSection: 0)
                        let sectionTwo = subject.tableView(subject.tableView, viewForHeaderInSection: 1) as! SectionHeaderViewCell
                        let sectionThree = subject.tableView(subject.tableView, viewForHeaderInSection: 2) as! SectionHeaderViewCell
                        
                        expect(sectionOne).to(beNil())
                        expect(sectionTwo).toNot(beNil())
                        expect(sectionTwo.titleLabel.text).to(equal("SECTION ONE"))
                        expect(sectionThree).toNot(beNil())
                        expect(sectionThree.titleLabel.text).to(equal("SECTION TWO"))
                    }
                }
            }

            describe("Tapping on a cell") {
                context("In the first section") {
                    beforeEach {
                        let indexPath = IndexPath(row: 0, section: 0)
                        subject.tableView(subject.tableView, didSelectRowAt: indexPath)
                    }
                    
                    it("does not call the delegate") {
                        expect(soundSelectionDelegate.calledDelegate).to(beFalsy())
                    }
                }
                
                context("In the second section") {
                    beforeEach {
                        let indexPath = IndexPath(row: 0, section: 1)
                        subject.tableView(subject.tableView, didSelectRowAt: indexPath)
                    }
                    
                    it("calls the delegate with the correct sound") {
                        expect(soundSelectionDelegate.calledDelegate).to(beTruthy())
                        expect(soundSelectionDelegate.capturedSound).toNot(beNil())
                        expect(soundSelectionDelegate.capturedSound!.identifier).to(equal(123))
                    }
                }
                
                context("In the third section") {
                    beforeEach {
                        let indexPath = IndexPath(row: 0, section: 2)
                        subject.tableView(subject.tableView, didSelectRowAt: indexPath)
                    }
                    
                    it("calls the delegate with the correct sound") {
                        expect(soundSelectionDelegate.calledDelegate).to(beTruthy())
                        expect(soundSelectionDelegate.capturedSound).toNot(beNil())
                        expect(soundSelectionDelegate.capturedSound!.identifier).to(equal(666))
                    }
                }
            }
        }

        describe(".viewDidLoad") {
            let soundOne = Sound(value: ["identifier": 123, "name": "Sound One"])
            let soundTwo = Sound(value: ["identifier": 111, "name": "Sound Two"])
            let soundThree = Sound(value: ["identifier": 666, "name": "Sound Three"])
            
            let soundGroups = [
                SoundGroup(value: ["identifier": 1, "name": "Section One", "sounds": [soundOne, soundTwo]]),
                SoundGroup(value: ["identifier": 2, "name": "Section Two", "sounds": [soundThree]])
            ]

            beforeEach {
                UIApplication.shared.keyWindow?.rootViewController = subject
                let _ = subject.view
            }

            it("gets the sounds from the cache") {
                expect(soundCache.calledGetSounds).to(beTruthy())
            }

            it("sets the title") {
                expect(subject.title).to(equal("Contacts"))
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
                describe(".tableView:titleForHeaderInSection:") {
                    it("Sets the title for the table sections") {
                        expect(subject.tableView(subject.tableView, titleForHeaderInSection: 0)).to(beNil())
                    }
                }
                
                describe(".numberOfSectionsInTableView") {
                    it("should have 2 sections") {
                        expect(subject.numberOfSections(in: subject.tableView)).to(equal(1))
                    }
                }

                describe(".tableView:numberOfRowsInSection:") {
                    it("should start with 1 row in the first section") {
                        expect(subject.tableView(subject.tableView, numberOfRowsInSection: 0)).to(equal(1))
                    }
                }
            }

            describe("When the cache resolves with sounds") {
                beforeEach {
                    soundCache.capturedGetSoundsCompletion!(soundGroups)
                }

                itBehavesLike("reloading sounds")
            }

            describe("Pulling to refresh") {
                beforeEach {
                    subject.refreshControl!.sendActions(for: .valueChanged)
                    subject.refreshControl!.beginRefreshing()
                }

                it("gets the sounds from the cache and refreashes the cache") {
                    expect(soundCache.calledGetSoundsAndRefreshCache).to(beTruthy())
                }

                describe("When the cache resolves with sounds") {
                    beforeEach {
                        soundCache.capturedGetSoundsAndRefreshCacheCompletion!(soundGroups)
                    }

                    itBehavesLike("reloading sounds")
                }
            }
        }

    }
}
