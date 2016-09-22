import SwiftyJSON
@testable import BestPractices

class MockSongListDeserializer: SongListDeserializerProtocol {
    var calledDeserialize = false
    var capturedJSON: JSON?

    func deserialize(json: JSON?) -> [Song] {
        calledDeserialize = true
        capturedJSON = json

        return [
            Song(value: ["identifier": 123, "name": "private eyes"]),
            Song(value: ["identifier": 456, "name": "rich girl"])
        ]
    }

}
