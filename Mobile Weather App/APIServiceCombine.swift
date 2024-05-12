import Combine
import Foundation

public class APIServiceCombine {
    public static let shared = APIServiceCombine()
    var cancellable =  Set<AnyCancellable>()
    public enum APIError: Error {
        case error(_ errorString: String)
    }
    
    public func getJSON<T: Decodable>(urlString: String,
                                      dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                      keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                                      completion: @escaping (Result<T,APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.error(NSLocalizedString("Error: Invalid URL", comment: ""))))
            return
        }
        let request = URLRequest(url: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        URLSession.shared.dataTaskPublisher(for: request)
            .map {$0.data}
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink { (taskCompletion) in
                switch taskCompletion {
                case .finished:
                    return
                case .failure (let decodingError):
                    completion(.failure(APIError.error("Error: \(decodingError.localizedDescription)")))
                }
            }receiveValue: { (decodedData) in
                completion(.success(decodedData))
            }
            .store(in: &cancellable)
    }
}
