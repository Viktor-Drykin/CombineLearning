import Foundation
import Combine
import SwiftUI

enum APIError: Error, CustomStringConvertible {

    case url(URLError?)
    case badResponse(statusCode: Int)
    case unknown(Error)

    static func convert(error: Error) -> APIError {
        switch error {
        case is URLError: return .url(error as? URLError)
        case is APIError: return error as! APIError
        default: return .unknown(error)
        }
    }

    var description: String {
        return ""
    }
}

public class ImageCollectionErrorHandlingFetcher: ObservableObject {
    public let loadImageSubject: CurrentValueSubject<String, Never> = .init("")
    @Published public  var images: [UIImage] = []

    public var imageNames: [String] = [
        "https://picsum.photos/100",
        "https://picsum.photos/150",
        "https://picsum.photos/200",
        "https://picsum.photos/250",
        "https://WITH_ERROR.photos/250"
    ]
    private var subscriptions = Set<AnyCancellable>()

    public init() {
        // Error handling: option 1 - setFailureType && mapError

        // Error handling: option 2 -> catchError and return Empty to avoid error in subscription completion

        // Error handling: option 3 -> replaceError before scan method, but it finishes subscription (result: receiveCompletion finished), that's why we need to use it in a flatMap because there is only one event

        loadImageSubject
            .removeDuplicates()
            .compactMap {
                URL(string: $0)
            }
            //.setFailureType(to: APIError.self)
            .flatMap { url -> AnyPublisher<UIImage, Never> in
                URLSession.shared.dataTaskPublisher(for: url)
                    .tryMap { (data, response) -> Data in
                        if let response = response as? HTTPURLResponse,
                           !(200...299).contains(response.statusCode) {
                            throw APIError.badResponse(statusCode: response.statusCode)
                        } else {
                            return data
                        }
                    }
                    .mapError{ error in
                        APIError.convert(error: error)
                    }
                    .compactMap {
                        UIImage(data: $0)
                    }
                    .replaceError(with: UIImage(named: "Error_image.png")!)
                    .retry(3)
                    .eraseToAnyPublisher()
            }
            .scan([UIImage]()) { all, next in
                [next] + all
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print(">>> receiveCompletion \(completion)")
            }, receiveValue: { [unowned self] images in
                print(">>> images count \(images.count)")
                self.images = images
            })
            .store(in: &subscriptions)

        loadImageSubject.send(imageNames[0])
        loadImageSubject.send(imageNames[1])
        loadImageSubject.send(imageNames[2])
        loadImageSubject.send(imageNames[3])
    }
}
