import Quick
import Nimble
import Fleet
@testable import BestPractices

class ImageServiceSpec: QuickSpec {
    override func spec() {

        var subject: ImageService!
        var httpClient: MockHTTPClient!

        beforeEach {
            subject = ImageService()

            httpClient = MockHTTPClient()
            subject.httpClient = httpClient
        }

        describe(".getImage") {
            var returnedImage: UIImage?
            var httpData: NSData?
            var calledCompletion: Bool!

            beforeEach {
                calledCompletion = false
                subject.getImage("imageURL", completion: { image in
                    calledCompletion = true
                    returnedImage = image
                })
            }

            it("calls the http client") {
                expect(httpClient.madeDataRequest).to(beTruthy())
                expect(httpClient.capturedDataURL).to(equal("imageURL"))
            }

            context("When the server responds with data") {
                beforeEach {
                    let bundle = NSBundle(forClass: self.dynamicType)
                    let path = bundle.pathForResource("hall_and_oates_cover", ofType: "jpeg")!
                    httpData = NSData(contentsOfFile: path)

                    httpClient.capturedDataCompletion!(httpData)
                }

                it("returns an image to the completion block") {
                    expect(calledCompletion).to(beTruthy())
                    expect(UIImageJPEGRepresentation(returnedImage!, 1.0)).to(equal(UIImageJPEGRepresentation(UIImage.init(data: httpData!)!, 1.0)))
                }
            }

            context("When the server does not respond with data") {
                beforeEach {
                    httpClient.capturedDataCompletion!(nil)
                }

                it("calls the completion with nil") {
                    expect(calledCompletion).to(beTruthy())
                    expect(returnedImage).to(beNil())
                }
            }
        }

    }
}
