import Quick
import Nimble
import AVFoundation
import AVKit
import MediaPlayer

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

            it("Hides unused remote media center commands") {
                let sc = MPRemoteCommandCenter.shared()
                let unused = [sc.seekForwardCommand, sc.seekForwardCommand, sc.skipBackwardCommand, sc.skipForwardCommand, sc.previousTrackCommand, sc.nextTrackCommand, sc.bookmarkCommand, sc.changePlaybackPositionCommand, sc.changePlaybackRateCommand, sc.changeRepeatModeCommand, sc.changeShuffleModeCommand, sc.dislikeCommand, sc.likeCommand, sc.pauseCommand, sc.ratingCommand, sc.togglePlayPauseCommand, sc.disableLanguageOptionCommand, sc.enableLanguageOptionCommand, sc.stopCommand]
                for command in unused {
                    expect(command.isEnabled).to(beFalsy())
                }
            }
        }
    }
}
