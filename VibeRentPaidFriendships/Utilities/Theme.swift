import SwiftUI

enum Theme {
    static let gradientStart = Color(red: 0.45, green: 0.2, blue: 0.85)
    static let gradientEnd = Color(red: 0.95, green: 0.45, blue: 0.2)
    static let accent = LinearGradient(colors: [gradientStart, gradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let cardBackground = Color(white: 0.11)
    static let surfaceBackground = Color(white: 0.08)
    static let verifiedBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let goldBorder = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let dangerRed = Color(red: 0.95, green: 0.25, blue: 0.25)

    static func avatarColors(for id: String) -> [Color] {
        let hash = abs(id.hashValue)
        let hue1 = Double(hash % 360) / 360.0
        let hue2 = Double((hash / 360) % 360) / 360.0
        return [
            Color(hue: hue1, saturation: 0.6, brightness: 0.7),
            Color(hue: hue2, saturation: 0.5, brightness: 0.5)
        ]
    }
}
