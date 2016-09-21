import SwiftyJSON
@testable import BestPractices

class MockSongListDeserializer: SongListDeserializerProtocol {
    var calledDeserialize = false
    var capturedJSON: JSON?

    func deserialize(json: JSON?) -> [Song] {
        calledDeserialize = true
        capturedJSON = json

        return [
            Song(identifier: 123, name: "private eyes", artist: "", url: "", albumArt: ""),
            Song(identifier: 456, name: "rich girl", artist: "", url: "", albumArt: "")
        ]
    }

}
