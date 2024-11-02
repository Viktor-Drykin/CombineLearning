import SwiftUI

public struct ImageView: View {

    @StateObject var imageFetcher = ImageFetcher()

    public init() {}

    public var body: some View {
        VStack {
            Text("Select image to download")
            List(imageFetcher.imageNames, id: \.self) { imageName in
                Button(action: {
                    imageFetcher.loadImageSubject.send(imageName)
                }, label: {
                    Text(imageName)
                        .bold()
                })
            }
            Divider()
            ZStack {
                Color.gray
                if let displayedImage = imageFetcher.image {
                    Image(uiImage: displayedImage)
                        .resizable()
                        .scaledToFit()
                        .padding()
                }
            }
        }
    }
}

