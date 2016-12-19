import SwiftyJSON
@testable import BestPractices

class MockSoundListDeserializer: SoundListDeserializerProtocol {
    var calledDeserialize = false
    var capturedJSON: JSON?
    var returnValueForDeserialize: [Song]?

    func deserialize(json: JSON?) -> [Song]? {
        calledDeserialize = true
        capturedJSON = json

        return returnValueForDeserialize
    }

}
