import Quick
import Nimble
import Fleet
@testable import BestPractices

class DispatcherSpec: QuickSpec {
    override func spec() {
        
        var subject: Dispatcher!
        
        beforeEach {
            subject = Dispatcher()
        }
        
        describe("With a real Dispatcher") {
            it("correctly sets the mainQueue property") {
                expect(subject.mainQueue).to(beIdenticalTo(NSOperationQueue.mainQueue()))
            }
        }
        
        describe("With fake dependencies") {
            var mainQueue: MockOperationQueue!
            
            beforeEach {
                mainQueue = MockOperationQueue()
                subject.mainQueue = mainQueue
            }
            
            describe(".dispatchToMainQueue") {
                var blockCalled = false
                
                beforeEach {
                    subject.dispatchToMainQueue({ blockCalled = true })
                }
                
                it("does not call the block until it is executed on the main queue") {
                    expect(blockCalled).to(beFalsy())
                }
                
                describe("After the main queue is executed") {
                    beforeEach {
                        mainQueue.completion!()
                    }
                    
                    it("executes the block passed in to the function") {
                        expect(blockCalled).to(beTruthy())
                    }
                }
            }
        }
        
    }
}
