import Quick
import Nimble
import Fleet
@testable import BestPractices

class HomeViewControllerSpec: QuickSpec {
    override func spec() {

        var subject: HomeViewController!
        var navigationController: UINavigationController!
        var listViewController: ListViewController!
        var imageService: MockImageService!
        var player: MockPlayer!

        beforeEach {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            listViewController = MockListViewController()
            try! storyboard.bindViewController(listViewController, toIdentifier: "ListViewController")

            subject = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController

            imageService = MockImageService()
            subject.imageService = imageService

            player = MockPlayer()
            subject.player = player

            navigationController = UINavigationController(rootViewController: subject)
        }

        describe(".viewDidLoad") {
            beforeEach {
                Fleet.setApplicationWindowRootViewController(navigationController)
            }

            it("has a button to go to the list view") {
                expect(subject.looseButton).toNot(beNil())
            }

            it("sets the title") {
                expect(subject.title).to(equal("YACHTY"))
            }

            it("does not load the player") {
                expect(player.loadedSong).to(beFalsy())
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
                    beforeEach {
                        let song = Song(identifier: 993, name: "Hall and Oates", artist: "", url: "", albumArt: "album_art")
                        subject.songWasSelected(song)
                    }

                    it("sets the label to the song name") {
                        expect(subject.currentSongLabel.text).to(equal("Hall and Oates"))
                    }

                    it("pops the list view controller off the navigation stack") {
                        expect(navigationController.topViewController).to(beIdenticalTo(subject))
                    }

                    it("calls the image service") {
                        expect(imageService.calledService).to(beTruthy())
                        expect(imageService.capturedURL).to(equal("album_art"))
                    }

                    it("loads the song into the player") {
                        expect(player.loadedSong).to(beTruthy())
                        expect(player.capturedLoadedSong!.identifier).to(equal(993))
                    }

                    describe("When the image service resolves") {
                        var image: UIImage?

                        context("If there was an issue and there is no image") {
                            beforeEach {
                                image = nil
                                imageService.completion(image)
                            }

                            it("leaves the imageview blank") {
                                expect(subject.albumArtImageView.image).to(beNil())
                            }
                        }

                        context("If the server properly returned an image") {
                            beforeEach {
                                let bundle = NSBundle(forClass: self.dynamicType)
                                let path = bundle.pathForResource("hall_and_oates_cover", ofType: "jpeg")!
                                image = UIImage(contentsOfFile: path)
                                imageService.completion(image)
                            }

                            it("sets the album art image") {
                                expect(subject.albumArtImageView.image).to(equal(image))
                            }
                        }
                    }
                }
            }
        }

    }
}
