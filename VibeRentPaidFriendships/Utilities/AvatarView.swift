import SwiftUI

struct AvatarView: View {
    let name: String
    let size: CGFloat
    let userId: String
    var isVerified: Bool = false
    var isFeatured: Bool = false

    private var initials: String {
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return "\(parts[0].prefix(1))\(parts[1].prefix(1))"
        }
        return String(name.prefix(2)).uppercased()
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: Theme.avatarColors(for: userId),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)

            Text(initials)
                .font(.system(size: size * 0.35, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
        }
        .overlay {
            if isFeatured {
                Circle()
                    .strokeBorder(
                        LinearGradient(colors: [Theme.goldBorder, Theme.goldBorder.opacity(0.5), Theme.goldBorder], startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 2.5
                    )
            }
        }
        .overlay(alignment: .bottomTrailing) {
            if isVerified {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: size * 0.3))
                    .foregroundStyle(Theme.verifiedBlue)
                    .background(Circle().fill(Color.black).padding(1))
                    .offset(x: 2, y: 2)
            }
        }
    }
}
