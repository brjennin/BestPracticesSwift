import Quick
import Nimble
import Fleet
@testable import BestPractices

class HomeViewControllerSpec: QuickSpec {
    override func spec() {

        var subject: HomeViewController!
        var navigationController: UINavigationController!
        var listViewController: ListViewController!
        var player: MockPlayer!
        var soundLoader: MockSoundLoader!
        var soundCache: MockSoundCache!

        let bundle = Bundle(for: type(of: self))
        let imagePath = bundle.path(forResource: "hall_and_oates_cover", ofType: "jpeg")!

        beforeEach {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            listViewController = MockListViewController()
            try! storyboard.bind(viewController: listViewController, toIdentifier: "ListViewController")

            subject = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController

            player = MockPlayer()
            subject.player = player

            soundLoader = MockSoundLoader()
            subject.soundLoader = soundLoader

            soundCache = MockSoundCache()
            subject.soundCache = soundCache

            navigationController = UINavigationController(rootViewController: subject)
        }

        sharedExamples("downloading sound assets") {
            describe("When the image asset has loaded") {
                context("When the image asset exists") {
                    let soundWithAssets = Sound(value: ["imageLocalPath": imagePath])

                    beforeEach {
                        soundLoader.capturedImageCompletion!(soundWithAssets)
                    }

                    it("sets the album art image") {
                        let image = UIImage(contentsOfFile: imagePath)!
                        let expectedData = UIImageJPEGRepresentation(image, 1)
                        expect(UIImageJPEGRepresentation(subject.albumArtImageView.image!, 1)).to(equal(expectedData))
                    }
                }

                context("When the image does not exist") {
                    let soundWithoutAssets = Sound()
                    soundWithoutAssets.imageLocalPath = nil

                    beforeEach {
                        soundLoader.capturedImageCompletion!(soundWithoutAssets)
                    }

                    it("clears the album art image") {
                        expect(subject.albumArtImageView.image).to(beNil())
                    }
                }
            }

            describe("When the sound asset has loaded") {
                let soundAssetPath = bundle.path(forResource: "maneater", ofType: "mp3")!

                context("When the sound asset exists") {
                    let soundWithAssets = Sound(value: ["soundLocalPath": soundAssetPath])

                    beforeEach {
                        soundLoader.capturedSoundCompletion!(soundWithAssets)
                    }

                    it("loads the sound into the player") {
                        expect(player.loadedSound).to(beTruthy())
                        expect(player.capturedFilePath!).to(equal(soundAssetPath))
                    }
                }

                context("When the sound asset does not exist") {
                    let soundWithoutAssets = Sound()
                    soundWithoutAssets.soundLocalPath = nil

                    beforeEach {
                        soundLoader.capturedSoundCompletion!(soundWithoutAssets)
                    }

                    it("does not load the sound into the player") {
                        expect(player.loadedSound).to(beFalsy())
                    }
                }
            }
        }

        describe(".viewDidLoad") {
            beforeEach {
                UIApplication.shared.keyWindow?.rootViewController = navigationController
            }

            it("has a button to go to the list view") {
                expect(subject.looseButton).toNot(beNil())
            }

            it("sets the title") {
                expect(subject.title).to(equal("YACHTY"))
            }

            it("gets the sounds from the cache") {
                expect(soundCache.calledGetSounds).to(beTruthy())
            }

            it("does not load the sound") {
                expect(player.loadedSound).to(beFalsy())
                expect(soundLoader.calledLoadSoundAssets).to(beFalsy())
            }
            
            it("clears text off the back button") {
                expect(subject.navigationItem.backBarButtonItem!.title!).to(equal(""))
            }

            it("clears label text") {
                expect(subject.currentSoundLabel.text).to(equal(""))
            }
            
            it("has default whammy values between 0 and 2") {
                expect(subject.whammySlider.minimumValue).to(equal(-0.2))
                expect(subject.whammySlider.maximumValue).to(equal(0.2))
                expect(subject.whammySlider.value).to(equal(0))
            }

            describe("When the cache resolves with sounds") {
                context("When there are sounds") {
                    let soundOne = Sound(value: ["identifier": 123, "name": "Sound One"])
                    let soundTwo = Sound(value: ["identifier": 111, "name": "Sound Two"])
                    let sounds = [soundOne, soundTwo]

                    beforeEach {
                        soundCache.capturedGetSoundsCompletion!(sounds)
                    }

                    it("calls the sound loader") {
                        expect(soundLoader.calledLoadSoundAssets).to(beTruthy())
                        expect(soundLoader.capturedSound!.identifier).to(equal(123))
                    }

                    it("sets the label to the sound name") {
                        expect(subject.currentSoundLabel.text).to(equal("Sound One"))
                    }

                    itBehavesLike("downloading sound assets")
                }

                context("When there are no sounds") {
                    beforeEach {
                        soundCache.capturedGetSoundsCompletion!([])
                    }

                    it("does not load a sound") {
                        expect(soundLoader.calledLoadSoundAssets).to(beFalsy())
                    }

                    it("has a nil album art image") {
                        expect(subject.albumArtImageView.image).to(beNil())
                    }

                    it("has blank label text") {
                        expect(subject.currentSoundLabel.text).to(equal(""))
                    }
                }
            }

            describe("Tapping on the play button") {
                context("With delay turned on") {
                    beforeEach {
                        subject.delaySwitch.setOn(true, animated: false)
                    }
                    
                    context("With reverb turned on") {
                        beforeEach {
                            subject.reverbNation.setOn(true, animated: false)
                            subject.playButton.tap()
                        }
                        
                        it("tells the player to play") {
                            expect(player.playedSound).to(beTruthy())
                            expect(player.capturedDelay).to(beTruthy())
                            expect(player.capturedReverb).to(beTruthy())
                        }
                    }
                    
                    context("With reverb turned off") {
                        beforeEach {
                            subject.reverbNation.setOn(false, animated: false)
                            subject.playButton.tap()
                        }
                        
                        it("tells the player to play") {
                            expect(player.playedSound).to(beTruthy())
                            expect(player.capturedDelay).to(beTruthy())
                            expect(player.capturedReverb).to(beFalsy())
                        }
                    }
                }

                context("With delay turned off") {
                    beforeEach {
                        subject.delaySwitch.setOn(false, animated: false)
                    }
                    
                    context("With reverb turned on") {
                        beforeEach {
                            subject.reverbNation.setOn(true, animated: false)
                            subject.playButton.tap()
                        }
                        
                        it("tells the player to play") {
                            expect(player.playedSound).to(beTruthy())
                            expect(player.capturedDelay).to(beFalsy())
                            expect(player.capturedReverb).to(beTruthy())
                        }
                    }
                    
                    context("With reverb turned off") {
                        beforeEach {
                            subject.reverbNation.setOn(false, animated: false)
                            subject.playButton.tap()
                        }
                        
                        it("tells the player to play") {
                            expect(player.playedSound).to(beTruthy())
                            expect(player.capturedDelay).to(beFalsy())
                            expect(player.capturedReverb).to(beFalsy())
                        }
                    }
                }
            }

            describe("Tapping on the button to get to the list view") {
                beforeEach {
                    subject.looseButton.tap()
                }

                it("takes the user to the list view controller") {
                    expect(navigationController.topViewController).to(beIdenticalTo(listViewController))
                }

                it("sets itself as the sound selection delegate") {
                    expect(listViewController.soundSelectionDelegate).to(beIdenticalTo(subject))
                }

                describe("As a SoundSelectionDelegate") {
                    beforeEach {
                        subject.albumArtImageView.image = UIImage(contentsOfFile: imagePath)
                        subject.currentSoundLabel.text = "something"

                        let sound = Sound(value: ["identifier": 993, "name": "Hall and Oates"])
                        subject.soundWasSelected(sound: sound)
                    }

                    it("calls the sound loader") {
                        expect(soundLoader.calledLoadSoundAssets).to(beTruthy())
                        expect(soundLoader.capturedSound!.identifier).to(equal(993))
                    }

                    it("pops the list view controller off the navigation stack") {
                        expect(navigationController.topViewController).to(beIdenticalTo(subject))
                    }

                    it("clears the album art image") {
                        expect(subject.albumArtImageView.image).to(beNil())
                    }

                    it("clears the previously loaded sound") {
                        expect(player.calledClearSound).to(beTruthy())
                    }

                    it("sets the label to the sound name") {
                        expect(subject.currentSoundLabel.text).to(equal("Hall and Oates"))
                    }

                    itBehavesLike("downloading sound assets")
                }
            }
            
            describe("Sliding the whammy bar") {
                beforeEach {
                    subject.whammySlider.value = 0.11
                    subject.didWhammy(subject.whammySlider)
                }
                
                it("calls the player with the whammy value") {
                    expect(player.calledPitchShift).to(beTruthy())
                    expect(player.capturedPitchShiftAmount).to(equal(0.11))
                }
            }
            
            describe("releasing the whammy bar") {
                beforeEach {
                    subject.whammySlider.value = 0.11
                    subject.didReleaseWhammy(subject.whammySlider)
                }
                
                it("calls the player with the whammy value 0") {
                    expect(player.calledPitchShift).to(beTruthy())
                    expect(player.capturedPitchShiftAmount).to(equal(0))
                }
                
                it("resets the bar to the center") {
                    expect(subject.whammySlider.value).to(equal(0))
                }
            }
        }

    }
}
