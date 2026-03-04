import SwiftUI

enum Theme {
    static let background = Color(red: 0.071, green: 0.071, blue: 0.071)
    static let cardBackground = Color(red: 0.118, green: 0.118, blue: 0.118)
    static let accent = Color(red: 0.42, green: 0.275, blue: 0.757)
    static let primaryText = Color.white
    static let secondaryText = Color(red: 0.627, green: 0.627, blue: 0.627)
    static let verifiedBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let dangerRed = Color(red: 0.9, green: 0.25, blue: 0.25)

    static func avatarColors(for id: String) -> [Color] {
        let hash = abs(id.hashValue)
        let hue1 = Double(hash % 360) / 360.0
        let hue2 = Double((hash / 360) % 360) / 360.0
        return [
            Color(hue: hue1, saturation: 0.45, brightness: 0.55),
            Color(hue: hue2, saturation: 0.4, brightness: 0.45)
        ]
    }
}
