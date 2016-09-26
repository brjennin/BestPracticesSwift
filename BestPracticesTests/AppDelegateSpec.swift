import Quick
import Nimble
import Fleet
@testable import BestPractices

class AppDelegateSpec: QuickSpec {
    override func spec() {
        
        var subject: AppDelegate!
        var application: UIApplication!
        
        beforeEach {
            application = UIApplication.sharedApplication()
            subject = AppDelegate()
        }
        
        describe(".application:didFinishLaunchingWithOptions:") {
            beforeEach {
                subject.application(application, didFinishLaunchingWithOptions: nil)
            }
            
            it("loads the view controller into the window") {
                expect(subject.window).toNot(beNil())
                expect(subject.window!.keyWindow).to(beTruthy())
                expect(subject.window!.frame).to(equal(UIScreen.mainScreen().bounds))
                expect(subject.window!.rootViewController).toNot(beNil())
                expect(subject.window!.rootViewController!).to(beAKindOf(UINavigationController))
                let navController = subject.window!.rootViewController! as! UINavigationController
                expect(navController.topViewController).toNot(beNil())
                expect(navController.topViewController!).to(beAKindOf(HomeViewController))                
            }
        }
    }
}
