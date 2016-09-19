import Quick
import Nimble
import Fleet
@testable import BestPractices

class HomeViewControllerSpec: QuickSpec {
    override func spec() {

        var subject: HomeViewController!
        var navigationController: UINavigationController!
        var listViewController: ListViewController!

        beforeEach {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            listViewController = MockListViewController()
            try! storyboard.bindViewController(listViewController, toIdentifier: "ListViewController")

            subject = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
            navigationController = UINavigationController(rootViewController: subject)
        }

        describe(".viewDidLoad") {
            beforeEach {
                Fleet.setApplicationWindowRootViewController(navigationController)
            }

            it("has a button to go to the list view") {
                expect(subject.looseButton).toNot(beNil())
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
                }
            }
        }

    }
}
