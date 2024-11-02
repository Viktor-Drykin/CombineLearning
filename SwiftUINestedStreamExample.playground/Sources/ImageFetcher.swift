import Foundation
import Combine
import SwiftUI

public class ImageFetcher: ObservableObject {
    @Published public var image: UIImage?
    public let loadImageSubject: CurrentValueSubject<String, Never> = .init("")

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
            .sink { [unowned self] _ in
                print("loadImageSubject nil")
                self.image = nil
            }
            .store(in: &subscriptions)

        loadImageSubject
            .removeDuplicates()
            .compactMap { URL(string: $0) }
            .map { url in
                URLSession.shared.dataTaskPublisher(for: url)
                    .map(\.data)
                    .compactMap { UIImage(data: $0) }
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print("loadImageSubject receiveCompletion \(completion)")
            }, receiveValue: { [unowned self] image in
                print("image not nil")
                self.image = image
            })
            .store(in: &subscriptions)
    }
}
