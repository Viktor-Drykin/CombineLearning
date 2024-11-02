import SwiftUI

public struct ImageCollectionView: View {
    @StateObject var fetcher = ImageCollectionFetcher()

    public init() {}

    public var body: some View {
        VStack {
            Text("Select image to download")
            List(fetcher.imageNames, id: \.self) { path in
                Button {
                    fetcher.loadImageSubject.send(path)
                } label: {
                    Text(path)
                }

            }
            List(fetcher.images, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
            }
        }
    }
}

