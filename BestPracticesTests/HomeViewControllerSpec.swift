import Quick
import Nimble
import Fleet
@testable import BestPractices

class HomeViewControllerSpec: QuickSpec {
    override func spec() {

        var subject: HomeViewController!
        var navigationController: UINavigationController!
        var listViewController: UIViewController!

        beforeEach {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            listViewController = UIViewController()
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
            }
        }

    }
}
