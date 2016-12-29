import Quick
import Nimble
@testable import BestPractices

class SoundCacheSpec: QuickSpec {

    override func spec() {

        var subject: SoundCache!
        var soundService: MockSoundService!
        var soundPersistence: MockSoundPersistence!

        var result: [SoundGroup]!

        beforeEach {
            subject = SoundCache()

            soundService = MockSoundService()
            subject.soundService = soundService

            soundPersistence = MockSoundPersistence()
            subject.soundPersistence = soundPersistence
        }

        describe(".getSoundsAndRefreshCache") {
            beforeEach {
                subject.getSoundsAndRefreshCache { returnedSounds in
                    result = returnedSounds
                }
            }

            it("calls the SoundService") {
                expect(soundService.calledService).to(beTruthy())
            }

            describe("When the service resolves") {
                context("When it resolves with sound groups") {
                    var groupOne: SoundGroup!
                    var groupTwo: SoundGroup!
                    var groups: [SoundGroup]!

                    beforeEach {
                        groupOne = SoundGroup(value: ["identifier": 111])
                        groupTwo = SoundGroup(value: ["identifier": 222])
                        groups = [groupOne, groupTwo]

                        soundService.completion!(groups, nil)
                    }

                    it("calls the completion with the sound list") {
                        expect(result.count).to(equal(2))
                        expect(result.first!.identifier).to(equal(111))
                        expect(result.last!.identifier).to(equal(222))
                    }

                    it("persists the sounds") {
                        expect(soundPersistence.calledReplace).to(beTruthy())
                        expect(soundPersistence.capturedReplaceSounds!.first!.identifier).to(equal(111))
                        expect(soundPersistence.capturedReplaceSounds!.last!.identifier).to(equal(222))
                    }
                }

                context("When it resolves without sounds") {
                    let error = NSError(domain: "com.example", code: 213, userInfo: nil)

                    context("When there are sounds persisted") {
                        beforeEach {
                            soundPersistence.soundsThatGetRetrieved = [
                                    SoundGroup(value: ["identifier": 831]),
                                    SoundGroup(value: ["identifier": 821]),
                            ]

                            soundService.completion!(nil, error)
                        }

                        it("does not replace the sounds in the persistence layer") {
                            expect(soundPersistence.calledReplace).to(beFalsy())
                        }

                        it("retrieves sounds from the persistence layer") {
                            expect(soundPersistence.calledRetrieve).to(beTruthy())
                        }

                        it("calls the completion with the result from the persistence layer") {
                            expect(result.first!.identifier).to(equal(831))
                            expect(result.last!.identifier).to(equal(821))
                        }
                    }

                    context("When there are no sounds persisted") {
                        beforeEach {
                            soundPersistence.soundsThatGetRetrieved = nil
                            soundService.completion!(nil, error)
                        }

                        it("does not replace the sounds in the persistence layer") {
                            expect(soundPersistence.calledReplace).to(beFalsy())
                        }

                        it("retrieves sounds from the persistence layer") {
                            expect(soundPersistence.calledRetrieve).to(beTruthy())
                        }

                        it("calls the completion with an empty array") {
                            expect(result.count).to(equal(0))
                        }
                    }

                }
            }

        }

        describe(".getSounds") {
            var result: [SoundGroup]!

            beforeEach {
                soundService.reset()
            }

            context("When the persistence layer has sounds") {
                beforeEach {
                    soundPersistence.soundsThatGetRetrieved = [
                            SoundGroup(value: ["identifier": 831]),
                            SoundGroup(value: ["identifier": 821]),
                    ]

                    subject.getSounds { returnedSounds in
                        result = returnedSounds
                    }
                }

                it("retrieves sounds from the persistence layer") {
                    expect(soundPersistence.calledRetrieve).to(beTruthy())
                }

                it("does not call the service") {
                    expect(soundService.calledService).to(beFalsy())
                }

                it("calls the completion with the result from the persistence layer") {
                    expect(result.first!.identifier).to(equal(831))
                    expect(result.last!.identifier).to(equal(821))
                }
            }

            context("When the persistence layer has no sounds") {
                beforeEach {
                    soundPersistence.soundsThatGetRetrieved = nil

                    subject.getSounds { returnedSounds in
                        result = returnedSounds
                    }
                }

                it("tries to retrieve sounds from the persistence layer") {
                    expect(soundPersistence.calledRetrieve).to(beTruthy())
                }

                it("calls the SoundService") {
                    expect(soundService.calledService).to(beTruthy())
                }

                describe("When the service resolves") {
                    context("When it resolves with sounds") {
                        var groupOne: SoundGroup!
                        var groupTwo: SoundGroup!
                        var groups: [SoundGroup]!
                        
                        beforeEach {
                            groupOne = SoundGroup(value: ["identifier": 111])
                            groupTwo = SoundGroup(value: ["identifier": 222])
                            groups = [groupOne, groupTwo]
                            
                            soundService.completion!(groups, nil)
                        }
                        
                        
                        it("calls the completion with the sound list") {
                            expect(result.count).to(equal(2))
                            expect(result.first!.identifier).to(equal(111))
                            expect(result.last!.identifier).to(equal(222))
                        }

                        it("persists the sounds") {
                            expect(soundPersistence.calledReplace).to(beTruthy())
                            expect(soundPersistence.capturedReplaceSounds!.first!.identifier).to(equal(111))
                            expect(soundPersistence.capturedReplaceSounds!.last!.identifier).to(equal(222))
                        }
                    }

                    context("When it resolves without sounds") {
                        let error = NSError(domain: "com.example", code: 213, userInfo: nil)

                        beforeEach {
                            soundPersistence.soundsThatGetRetrieved = nil
                            soundService.completion!(nil, error)
                        }

                        it("does not replace the sounds in the persistence layer") {
                            expect(soundPersistence.calledReplace).to(beFalsy())
                        }

                        it("calls the completion with an empty array") {
                            expect(result.count).to(equal(0))
                        }
                    }
                }
            }
        }

    }
}
