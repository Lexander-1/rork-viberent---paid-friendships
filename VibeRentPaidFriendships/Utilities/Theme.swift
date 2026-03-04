import SwiftUI

enum Theme {
    static let background = Color(hex: 0x121212)
    static let cardBackground = Color(hex: 0x1E1E1E)
    static let accent = Color(hex: 0x6B46C1)
    static let primaryText = Color.white
    static let secondaryText = Color(hex: 0xA0A0A0)
    static let border = Color(hex: 0x333333)
    static let verifiedBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let dangerRed = Color(red: 0.9, green: 0.25, blue: 0.25)
}

extension Color {
    init(hex: UInt) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0
        )
    }
}
