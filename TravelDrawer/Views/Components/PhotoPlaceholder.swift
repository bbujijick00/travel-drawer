import SwiftUI

/// Diagonal-stripe placeholder standing in for a real photo or map tile.
/// Swap for `AsyncImage`/a maps SDK once real photo & map assets exist.
struct PhotoPlaceholder: View {
    var cornerRadius: CGFloat = 0

    var body: some View {
        Canvas { context, size in
            context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(DT.Colors.subSurfaceAlt))
            let stripe = 14.0
            var x = -size.height
            var path = Path()
            while x < size.width {
                path.move(to: CGPoint(x: x, y: size.height))
                path.addLine(to: CGPoint(x: x + size.height, y: 0))
                x += stripe
            }
            context.stroke(path, with: .color(DT.Colors.textFainter.opacity(0.35)), lineWidth: 6)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

#Preview {
    PhotoPlaceholder(cornerRadius: 16)
        .frame(width: 200, height: 120)
        .padding()
}
