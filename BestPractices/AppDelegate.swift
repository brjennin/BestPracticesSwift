import UIKit
import AVFoundation
import AVKit
import MediaPlayer

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var applicationProvider: ApplicationProviderProtocol! = ApplicationProvider()
    static let applicationName = "U DON'T HAVE TO CALL"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "NavigationController")

        window = UIWindow.init(frame: UIScreen.main.bounds)
        window!.rootViewController = homeViewController
        window!.makeKeyAndVisible()

        let sharedApplication = applicationProvider.sharedApplication()
        sharedApplication.beginReceivingRemoteControlEvents()

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {

        }

        let sc = MPRemoteCommandCenter.shared()
        let unusedCommands = [sc.seekForwardCommand, sc.seekForwardCommand, sc.skipBackwardCommand, sc.skipForwardCommand, sc.previousTrackCommand, sc.nextTrackCommand, sc.bookmarkCommand, sc.changePlaybackPositionCommand, sc.changePlaybackRateCommand, sc.changeRepeatModeCommand, sc.changeShuffleModeCommand, sc.dislikeCommand, sc.likeCommand, sc.pauseCommand, sc.ratingCommand, sc.togglePlayPauseCommand, sc.disableLanguageOptionCommand, sc.enableLanguageOptionCommand, sc.stopCommand]
        for command in unusedCommands {
            command.isEnabled = false
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
