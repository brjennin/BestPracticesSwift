import Quick
import Nimble
import AVFoundation
import AVKit
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

                _ = subject.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
            }

            it("loads the view controller into the window") {
                expect(subject.window).toNot(beNil())
                expect(subject.window!.isKeyWindow).to(beTruthy())
                expect(subject.window!.frame).to(equal(UIScreen.main.bounds))
                expect(subject.window!.rootViewController).toNot(beNil())
                expect(subject.window!.rootViewController!).to(beAKindOf(UINavigationController.self))
                let navController = subject.window!.rootViewController! as! UINavigationController
                expect(navController.topViewController).toNot(beNil())
                expect(navController.topViewController!).to(beAKindOf(HomeViewController.self))
            }

            it("calls the application provider") {
                expect(applicationProvider.calledSharedApplication).to(beTruthy())
            }

            it("starts listening for remote control events") {
                expect(application.calledBeginReceivingRemoteControlEvents).to(beTruthy())
            }

            it("sets the audio session category") {
                expect(AVAudioSession.sharedInstance()).toNot(beNil())
                expect(AVAudioSession.sharedInstance().category).to(equal(AVAudioSessionCategoryPlayback))
            }
        }
    }
}
