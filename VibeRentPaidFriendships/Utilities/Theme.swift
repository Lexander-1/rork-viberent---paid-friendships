import SwiftUI

@Observable
@MainActor
class ThemeManager {
    static let shared = ThemeManager()
    var currentTheme: AppTheme = .dark

    var background: Color {
        switch currentTheme {
        case .dark: return Color(hex: 0x181818)
        case .light: return Color(hex: 0xF5F5F5)
        case .monotoneBlue: return Color(hex: 0x001F3F)
        case .monotoneRed: return Color(hex: 0x3F0000)
        case .monotoneBrown: return Color(hex: 0x3F2A1D)
        }
    }

    var cardBackground: Color {
        switch currentTheme {
        case .dark: return Color(hex: 0x2A1616)
        case .light: return Color(hex: 0xFFFFFF)
        case .monotoneBlue: return Color(hex: 0x002B55)
        case .monotoneRed: return Color(hex: 0x551111)
        case .monotoneBrown: return Color(hex: 0x55392A)
        }
    }

    var primaryText: Color {
        switch currentTheme {
        case .light: return Color(hex: 0x1A1A1A)
        default: return Color(hex: 0xF5F5F5)
        }
    }

    var secondaryText: Color {
        switch currentTheme {
        case .light: return Color(hex: 0x666666)
        default: return Color(hex: 0xC0C0C0)
        }
    }

    var border: Color {
        switch currentTheme {
        case .light: return Color(hex: 0xDDDDDD)
        default: return Color(hex: 0x400000)
        }
    }

    var colorScheme: ColorScheme {
        currentTheme == .light ? .light : .dark
    }
}

enum Theme {
    static let background = Color(hex: 0x181818)
    static let cardBackground = Color(hex: 0x2A1616)
    static let accent = Color(hex: 0x9C2A2A)
    static let buttonBackground = Color(hex: 0x400000)
    static let primaryText = Color(hex: 0xF5F5F5)
    static let secondaryText = Color(hex: 0xC0C0C0)
    static let border = Color(hex: 0x400000)
    static let verifiedBadge = Color(hex: 0xC77A7A)
    static let accentRed = Color(hex: 0x9C2A2A)
    static let dangerRed = Color(hex: 0x9C2A2A)
    static let gold = Color(hex: 0xFFD700)
    static let buttonGlow = Color(hex: 0x9C2A2A).opacity(0.5)
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
