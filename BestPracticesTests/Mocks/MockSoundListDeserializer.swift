import SwiftyJSON
@testable import BestPractices

class MockSoundListDeserializer: SoundListDeserializerProtocol {
    var calledDeserialize = false
    var capturedJSON: JSON?
    var returnValueForDeserialize: [Sound]?

    func deserialize(json: JSON?) -> [Sound]? {
        calledDeserialize = true
        capturedJSON = json

        return returnValueForDeserialize
    }

}
