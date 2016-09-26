@testable import BestPractices

class MockApplicationProvider: ApplicationProviderProtocol {
    var calledSharedApplication = false
    var returnValueForSharedApplication: ApplicationProtocol!
    
    func sharedApplication() -> ApplicationProtocol {
        calledSharedApplication = true
        return returnValueForSharedApplication
    }
}
