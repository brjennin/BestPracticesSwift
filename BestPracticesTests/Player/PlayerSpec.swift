import Quick
import Nimble
import Fleet
import AVKit
import AVFoundation
@testable import BestPractices

class PlayerSpec: QuickSpec {
    override func spec() {

        var subject: Player!
        var httpClient: MockHTTPClient!

        beforeEach {
            subject = Player()

            httpClient = MockHTTPClient()
            subject.httpClient = httpClient
        }

        describe(".loadSong") {
            let song = Song(value: ["identifier": 23311, "url": "url"])

            context("With a good URL") {
                beforeEach {
                    subject.loadSong(song)
                }

                it("calls the HTTP client with the url") {
                    expect(httpClient.madeDownloadRequest).to(beTruthy())
                    expect(httpClient.capturedDownloadURL).to(equal("url"))
                    expect(httpClient.capturedFolderPath).to(equal("songs/23311/"))
                }

                it("does not initialize an audio player until we have a song file") {
                    expect(subject.audioPlayer).to(beNil())
                }

                describe("When the http client resolves") {
                    let bundle = NSBundle(forClass: self.dynamicType)
                    let path = bundle.pathForResource("maneater", ofType: "mp3")!
                    let sampleFileURL = NSURL(fileURLWithPath: path)

                    beforeEach {
                        httpClient.capturedDownloadCompletion!(sampleFileURL)
                    }

                    it("loads the song into the audio player") {
                        expect(subject.audioPlayer).toNot(beNil())
                        expect(subject.audioPlayer!.url!).to(equal(sampleFileURL))
                    }
                }
            }

            context("With no URL") {
                beforeEach {
                    subject.loadSong(song)
                }

                it("calls the HTTP client with the url") {
                    expect(httpClient.madeDownloadRequest).to(beTruthy())
                    expect(httpClient.capturedDownloadURL).to(equal("url"))
                    expect(httpClient.capturedFolderPath).to(equal("songs/23311/"))
                }

                it("does not initialize an audio player until we have a song file") {
                    expect(subject.audioPlayer).to(beNil())
                }

                describe("When the http client resolves") {
                    beforeEach {
                        httpClient.capturedDownloadCompletion!(nil)
                    }

                    it("loads the song into the audio player") {
                        expect(subject.audioPlayer).to(beNil())
                    }
                }
            }

            context("With a bad URL") {
                beforeEach {
                    subject.loadSong(song)
                }

                it("calls the HTTP client with the url") {
                    expect(httpClient.madeDownloadRequest).to(beTruthy())
                    expect(httpClient.capturedDownloadURL).to(equal("url"))
                    expect(httpClient.capturedFolderPath).to(equal("songs/23311/"))
                }

                it("does not initialize an audio player until we have a song file") {
                    expect(subject.audioPlayer).to(beNil())
                }

                describe("When the http client resolves") {
                    beforeEach {
                        httpClient.capturedDownloadCompletion!(NSURL(fileURLWithPath: "http://www.example.com"))
                    }

                    it("loads the song into the audio player") {
                        expect(subject.audioPlayer).to(beNil())
                    }
                }
            }
        }

        describe(".play") {
            context("When there is a song loaded") {
                let bundle = NSBundle(forClass: self.dynamicType)
                let path = bundle.pathForResource("maneater", ofType: "mp3")!
                let sampleFileURL = NSURL(fileURLWithPath: path)
                let player = try! AVAudioPlayer(contentsOfURL: sampleFileURL)

                beforeEach {
                    subject.audioPlayer = player
                    subject.play()
                }

                afterEach {
                    subject.audioPlayer!.stop()
                }

                it("plays the song") {
                    expect(subject.audioPlayer!.playing).to(beTruthy())
                }
            }

            context("When there is no song loaded") {
                beforeEach {
                    subject.audioPlayer = nil
                }

                it("plays the song") {
                    expect(subject.play()).toNot(throwError())
                }
            }
        }

    }
}
