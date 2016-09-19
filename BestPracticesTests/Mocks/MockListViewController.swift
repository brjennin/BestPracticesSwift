@testable import BestPractices

class MockListViewController: ListViewController {
    override var songService: SongServiceProtocol! {
        get { return MockSongService() }
        set { self.songService = newValue }
    }
    override var dispatcher: DispatcherProtocol! {
        get { return MockDispatcher() }
        set { self.dispatcher = newValue }
    }
}
