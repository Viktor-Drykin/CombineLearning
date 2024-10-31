import SwiftUI
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

class MyModel: ObservableObject {
    
    @Published var lastUpdate = Date()

    init() {
        Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .assign(to: &$lastUpdate)
    }
}

struct ClockView: View {
    @StateObject var model = MyModel()

    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }

    var body: some View {
        Text(dateFormatter.string(from: model.lastUpdate))
            .fixedSize()
            .padding(50)
    }
}

PlaygroundPage.current.setLiveView(ClockView())
