import Quick
import Nimble
import Fleet
@testable import BestPractices

class AppDelegateSpec: QuickSpec {
    override func spec() {
        
        var subject: AppDelegate!
        var application: MockApplication!
        var applicationProvider: MockApplicationProvider!
        
        beforeEach {
            subject = AppDelegate()
            
            applicationProvider = MockApplicationProvider()
            subject.applicationProvider = applicationProvider
        }
        
        describe(".application:didFinishLaunchingWithOptions:") {
            beforeEach {
                application = MockApplication()
                applicationProvider.returnValueForSharedApplication = application
                
                subject.application(UIApplication.sharedApplication(), didFinishLaunchingWithOptions: nil)
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
            
            it("calls the application provider") {
                expect(applicationProvider.calledSharedApplication).to(beTruthy())
            }
            
            it("starts listening for remote control events") {
                expect(application.calledBeginReceivingRemoteControlEvents).to(beTruthy())
            }
        }
    }
}
