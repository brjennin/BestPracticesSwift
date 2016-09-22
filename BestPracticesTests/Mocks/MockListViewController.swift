@testable import BestPractices

class MockListViewController: ListViewController {
    override var songCache: SongCacheProtocol! {
        get { return MockSongCache() }
        set { self.songCache = newValue }
    }
    override var dispatcher: DispatcherProtocol! {
        get { return MockDispatcher() }
        set { self.dispatcher = newValue }
    }
}
