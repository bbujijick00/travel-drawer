import SwiftUI

/// Shows a saved photo if `filename` resolves to one on disk, otherwise falls
/// back to the striped placeholder.
struct PlacePhotoView: View {
    let filename: String?
    var cornerRadius: CGFloat = 0

    var body: some View {
        if let filename, let image = PhotoStorage.loadImage(filename: filename) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        } else {
            PhotoPlaceholder(cornerRadius: cornerRadius)
        }
    }
}
