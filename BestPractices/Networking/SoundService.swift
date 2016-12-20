import SwiftyJSON

protocol SoundServiceProtocol: class {
    func getSounds(completion: @escaping (([Sound]?, NSError?) -> ()))
}

class SoundService: SoundServiceProtocol {

    var requestProvider: RequestProviderProtocol! = RequestProvider()
    var httpClient: HTTPClientProtocol! = HTTPClient()
    var soundListDeserializer: SoundListDeserializerProtocol! = SoundListDeserializer()

    func getSounds(completion: @escaping (([Sound]?, NSError?) -> ())) {
        let request = self.requestProvider.getSoundsListRequest()
        self.httpClient.makeJsonRequest(request: request) { [weak self] jsonObject, error in
            completion(self?.soundListDeserializer.deserialize(json: jsonObject), error)
        }
    }

}
