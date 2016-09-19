import Quick
import Nimble
import Fleet
import SwiftyJSON
@testable import BestPractices

class SongServiceSpec: QuickSpec {
    override func spec() {
        
        var subject: SongService!
        var requestProvider: MockRequestProvider!
        var httpClient: MockHTTPClient!
        
        beforeEach {
            subject = SongService()
            
            requestProvider = MockRequestProvider()
            subject.requestProvider = requestProvider
            
            httpClient = MockHTTPClient()
            subject.httpClient = httpClient
        }
        
        describe(".getSongs") {
            var returnedSongs: [Song]!
            
            beforeEach {
                subject.getSongs({ songs in returnedSongs = songs })
            }
            
            it("gets a request from the request provider") {
                expect(requestProvider.calledGetSongsListRequest).to(beTruthy())
            }
            
            it("makes a request") {
                expect(httpClient.capturedRequest!.urlString).to(equal("getSongsList"))
            }
            
            describe("When the HTTP call resolves") {
                context("When there are songs") {
                    beforeEach {
                        let bundle = NSBundle(forClass: self.dynamicType)
                        let path = bundle.pathForResource("getSongsListResponse", ofType: "json")!
                        let jsonData = NSData(contentsOfFile: path)
                        let json = JSON(data: jsonData!)
                        httpClient.capturedCompletion!(json)
                    }
                    
                    it("deserializes song objects") {
                        expect(returnedSongs.count).to(equal(2))
                        expect(returnedSongs.first!.name).to(equal("Maneater"))
                        expect(returnedSongs.last!.name).to(equal("Private Eyes"))
                    }
                }
                
                context("When there are no songs") {
                    beforeEach {
                        let jsonData = NSData(base64EncodedString: "[]", options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                        let json = JSON(data: jsonData!)
                        httpClient.capturedCompletion!(json)
                    }
                    
                    it("deserializes an empty array") {
                        expect(returnedSongs.count).to(equal(0))
                    }
                }
                
                context("When the server errors") {
                    beforeEach {
                        httpClient.capturedCompletion!(nil)
                    }
                    
                    it("returns an empty array") {
                        expect(returnedSongs.count).to(equal(0))
                    }
                }
            }
        }
        
    }
}
