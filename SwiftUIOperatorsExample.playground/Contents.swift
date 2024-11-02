import SwiftUI
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// MARK: Model
struct Quote: Decodable, Hashable {
    let quoteText: String
    let author: String
}

// MARK: View Model
final class QuoteFetcher: ObservableObject {

    @Published var quotes = [Quote]()

    private let fileNames: [String] = ["quote1", "quote2", "quote3"]
    private var subscriptions = Set<AnyCancellable>()

    init() {
        fileNames
            .publisher
            .compactMap {
                Bundle.main.url(forResource: $0, withExtension: "json")
            }
            .tryMap {
                try Data.init(contentsOf: $0) }
            .decode(type: Quote.self, decoder: JSONDecoder())
            .sink { completion in
                print(">>> completion \(completion)")
            } receiveValue: { [unowned self] quote in
                self.quotes.append(quote)
            }
            .store(in: &subscriptions)
    }
}
// MARK: View
struct QuotesView: View {

    @StateObject var quoteFetcher: QuoteFetcher = QuoteFetcher()

    var body: some View {
        VStack {
            Text("Quotes")
                .font(.title)
            
            List(quoteFetcher.quotes, id: \.self) { quote in
                VStack(alignment: .trailing) {
                    Text(quote.quoteText)
                    Text(quote.author)
                        .bold()
                }
            }
        }
    }
}


PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.setLiveView(QuotesView().frame(width: 300, height: 500))
