@testable import BestPractices

class MockListViewController: ListViewController {
    override var soundCache: SoundCacheProtocol! {
        get { return MockSoundCache() }
        set { self.soundCache = newValue }
    }
    override var dispatcher: DispatcherProtocol! {
        get { return MockDispatcher() }
        set { self.dispatcher = newValue }
    }
}
