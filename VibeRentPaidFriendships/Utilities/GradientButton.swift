import SwiftUI

struct GradientButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var isFullWidth: Bool = true
    var isSmall: Bool = false
    @State private var isPressed: Bool = false

    init(_ title: String, icon: String? = nil, isFullWidth: Bool = true, isSmall: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isFullWidth = isFullWidth
        self.isSmall = isSmall
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                        .font(isSmall ? .subheadline.bold() : .body.bold())
                }
                Text(title)
                    .font(isSmall ? .subheadline.bold() : .body.bold())
            }
            .foregroundStyle(Theme.primaryText)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .padding(.horizontal, isSmall ? 16 : 24)
            .padding(.vertical, isSmall ? 10 : 16)
            .background(Theme.buttonBackground)
            .clipShape(.rect(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.accentRed.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: Theme.buttonGlow, radius: 6, x: 0, y: 0)
        }
        .buttonStyle(ScaleTapStyle())
    }
}

struct ScaleTapStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
