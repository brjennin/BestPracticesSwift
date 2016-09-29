import Foundation
@testable import BestPractices

class MockAVAudioEngine: AudioEngineProtocol {
    var calledPrepare = false
    
    func prepare() {
        calledPrepare = true
    }
    
    var calledStart = false
    var startShouldThrow: Bool!
    
    func start() throws {
        calledStart = true
        
        if startShouldThrow! {
            throw NSError(domain: "com.audioplayer", code: 123, userInfo: nil)
        }
    }
}
