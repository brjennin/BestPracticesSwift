import SwiftyJSON
@testable import BestPractices

class MockSongListDeserializer: SongListDeserializerProtocol {
    var calledDeserialize = false
    var capturedJSON: JSON?
    var returnValueForDeserialize: [Song]?

    func deserialize(json: JSON?) -> [Song]? {
        calledDeserialize = true
        capturedJSON = json

        return returnValueForDeserialize
    }

}
