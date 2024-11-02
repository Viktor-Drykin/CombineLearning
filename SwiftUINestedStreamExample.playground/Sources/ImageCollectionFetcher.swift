import Foundation
import Combine
import SwiftUI

public class ImageCollectionFetcher: ObservableObject {
    public let loadImageSubject: CurrentValueSubject<String, Never> = .init("")
    @Published public  var images: [UIImage] = []

    public var imageNames: [String] = [
        "https://picsum.photos/100",
        "https://picsum.photos/150",
        "https://picsum.photos/200",
        "https://picsum.photos/250"
    ]
    private var subscriptions = Set<AnyCancellable>()

    public init() {

        loadImageSubject
            .removeDuplicates()
            .compactMap {
                URL(string: $0)
            }
        //will keep in buffer data. If there is no buffer and we call flatMap one by one then we will get first value and the last because when URLSession request is finished loadImageSubject will keep only the last one
            .buffer(size: 100, prefetch: .byRequest, whenFull: .dropOldest)
        //maxPublishers 1 to call it one by one
            .flatMap(maxPublishers: .max(1)) { url in
                URLSession.shared.dataTaskPublisher(for: url)
                    .map(\.data)
                    .compactMap {
                        UIImage(data: $0)
                    }
                    .catch { _ in
                        Empty()
                    }
            }
            .scan([UIImage]()) { all, next in
                all + [next]
            }
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] images in
                print(">>> images count \(images.count)")
                self.images = images
            }
            .store(in: &subscriptions)

        loadImageSubject.send(imageNames[0])
        loadImageSubject.send(imageNames[1])
        loadImageSubject.send(imageNames[2])
        loadImageSubject.send(imageNames[3])
    }
}
