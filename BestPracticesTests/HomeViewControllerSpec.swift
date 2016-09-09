import Quick
import Nimble
import Fleet
@testable import BestPractices

class HomeViewControllerSpec: QuickSpec {
    override func spec() {

        var subject: HomeViewController!

        beforeEach {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            subject = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        }

        describe(".viewDidLoad") {
            beforeEach {
                Fleet.setApplicationWindowRootViewController(subject)
            }

            it("has a view") {
                expect(subject.view).toNot(beNil())
            }
        }

    }
}
