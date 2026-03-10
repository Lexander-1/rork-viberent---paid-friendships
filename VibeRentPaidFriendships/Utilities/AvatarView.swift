import SwiftUI

struct AvatarView: View {
    let name: String
    let size: CGFloat
    let userId: String
    var isVerified: Bool = false

    private var initials: String {
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return "\(parts[0].prefix(1))\(parts[1].prefix(1))"
        }
        return String(name.prefix(2)).uppercased()
    }

    private var backgroundColor: Color {
        let hash = abs(userId.hashValue)
        let hue = Double(hash % 360) / 360.0
        return Color(hue: hue, saturation: 0.35, brightness: 0.45)
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: size, height: size)

            Text(initials)
                .font(.system(size: size * 0.35, weight: .bold))
                .foregroundStyle(Theme.primaryText)
        }
        .overlay(alignment: .bottomTrailing) {
            if isVerified {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: size * 0.3))
                    .foregroundStyle(Theme.verifiedBadge)
                    .background(Circle().fill(Theme.background).padding(1))
                    .offset(x: 2, y: 2)
            }
        }
    }
}
