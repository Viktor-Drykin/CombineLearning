import SwiftUI
import Combine
import PlaygroundSupport

struct ContentView: View {

    var body: some View {
        TabView {
            ImageView()
                .tabItem {
                    Text("One Image")
                }
            ImageCollectionView()
                .tabItem {
                    Text("Images' Collection")
                }
        }
    }
}

//PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.setLiveView(ContentView().frame(width: 300, height: 500))
