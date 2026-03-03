import SwiftUI

struct GradientButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var isFullWidth: Bool = true
    var isSmall: Bool = false

    init(_ title: String, icon: String? = nil, isFullWidth: Bool = true, isSmall: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isFullWidth = isFullWidth
        self.isSmall = isSmall
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                        .font(isSmall ? .subheadline.bold() : .body.bold())
                }
                Text(title)
                    .font(isSmall ? .subheadline.bold() : .body.bold())
            }
            .foregroundStyle(.white)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .padding(.horizontal, isSmall ? 16 : 24)
            .padding(.vertical, isSmall ? 10 : 16)
            .background(Theme.accent)
            .clipShape(.capsule)
        }
    }
}
