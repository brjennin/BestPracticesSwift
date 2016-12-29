import SwiftyJSON
@testable import BestPractices

class MockSoundListDeserializer: SoundListDeserializerProtocol {
    var calledDeserialize = false
    var capturedJSON: JSON?
    var returnValueForDeserialize: [SoundGroup]?

    func deserialize(json: JSON?) -> [SoundGroup]? {
        calledDeserialize = true
        capturedJSON = json

        return returnValueForDeserialize
    }

}
