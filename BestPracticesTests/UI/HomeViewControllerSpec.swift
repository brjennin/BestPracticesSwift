import Quick
import Nimble
import Fleet
@testable import BestPractices

class HomeViewControllerSpec: QuickSpec {
    override func spec() {

        var subject: HomeViewController!
        var navigationController: UINavigationController!
        var listViewController: ListViewController!
        var player: MockPlayer!
        var songLoader: MockSongLoader!

        beforeEach {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            listViewController = MockListViewController()                                
            try! storyboard.bindViewController(listViewController, toIdentifier: "ListViewController")

            subject = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController

            player = MockPlayer()
            subject.player = player
            
            songLoader = MockSongLoader()
            subject.songLoader = songLoader

            navigationController = UINavigationController(rootViewController: subject)
        }

        describe(".viewDidLoad") {
            beforeEach {
                UIApplication.shared.keyWindow?.rootViewController = navigationController
            }

            it("has a button to go to the list view") {
                expect(subject.looseButton).toNot(beNil())
            }

            it("sets the title") {
                expect(subject.title).to(equal("YACHTY"))
            }

            it("does not load the song") {
                expect(player.loadedSong).to(beFalsy())
                expect(songLoader.calledLoadSongAssets).to(beFalsy())
            }

            it("clears label text") {
                expect(subject.currentSongLabel.text).to(equal(""))
            }

            describe("Tapping on the play button") {
                beforeEach {
                    subject.playButton.tap()
                }

                it("tells the player to play") {
                    expect(player.playedSong).to(beTruthy())
                }
            }

            describe("Tapping on the button to get to the list view") {
                beforeEach {
                    subject.looseButton.tap()
                }

                it("takes the user to the list view controller") {
                    expect(navigationController.topViewController).to(beIdenticalTo(listViewController))
                }

                it("sets itself as the song selection delegate") {
                    expect(listViewController.songSelectionDelegate).to(beIdenticalTo(subject))
                }

                describe("As a SongSelectionDelegate") {
                    let bundle = Bundle(for: type(of: self))
                    let imagePath = bundle.path(forResource: "hall_and_oates_cover", ofType: "jpeg")!
                    
                    beforeEach {
                        subject.albumArtImageView.image = UIImage(contentsOfFile: imagePath)
                        subject.currentSongLabel.text = "something"
                        
                        let song = Song(value: ["identifier": 993, "name": "Hall and Oates"])
                        subject.songWasSelected(song: song)
                    }

                    it("calls the song loader") {
                        expect(songLoader.calledLoadSongAssets).to(beTruthy())
                        expect(songLoader.capturedSong!.identifier).to(equal(993))
                    }
                    
                    it("pops the list view controller off the navigation stack") {
                        expect(navigationController.topViewController).to(beIdenticalTo(subject))
                    }
                    
                    it("clears the album art image") {
                        expect(subject.albumArtImageView.image).to(beNil())
                    }
                    
                    it("clears the previously loaded song") {
                        expect(player.calledClearSong).to(beTruthy())
                    }
                    
                    it("sets the label to the song name") {
                        expect(subject.currentSongLabel.text).to(equal("Hall and Oates"))
                    }
                    
                    describe("When the image asset has loaded") {
                        context("When the image asset exists") {
                            let songWithAssets = Song(value: ["imageLocalPath": imagePath])
                            
                            beforeEach {
                                songLoader.capturedImageCompletion!(songWithAssets)
                            }
                            
                            it("sets the album art image") {
                                let image = UIImage(contentsOfFile: imagePath)!
                                let expectedData = UIImageJPEGRepresentation(image, 1)
                                expect(UIImageJPEGRepresentation(subject.albumArtImageView.image!, 1)).to(equal(expectedData))
                            }
                        }
                        
                        context("When the image does not exist") {
                            let songWithoutAssets = Song()
                            songWithoutAssets.imageLocalPath = nil
                            
                            beforeEach {
                                songLoader.capturedImageCompletion!(songWithoutAssets)
                            }
                            
                            it("clears the album art image") {
                                expect(subject.albumArtImageView.image).to(beNil())
                            }
                        }
                    }
                    
                    describe("When the song asset has loaded") {
                        let songAssetPath = bundle.path(forResource: "maneater", ofType: "mp3")!
                        
                        context("When the song asset exists") {
                            let songWithAssets = Song(value: ["songLocalPath": songAssetPath])
                            
                            beforeEach {
                                songLoader.capturedSongCompletion!(songWithAssets)
                            }
                            
                            it("loads the song into the player") {
                                expect(player.loadedSong).to(beTruthy())
                                expect(player.capturedFilePath!).to(equal(songAssetPath))
                            }
                        }
                        
                        context("When the song asset does not exist") {
                            let songWithoutAssets = Song()
                            songWithoutAssets.songLocalPath = nil
                            
                            beforeEach {
                                songLoader.capturedSongCompletion!(songWithoutAssets)
                            }
                            
                            it("does not load the song into the player") {
                                expect(player.loadedSong).to(beFalsy())
                            }
                        }
                    }
                }
            }
        }

    }
}
