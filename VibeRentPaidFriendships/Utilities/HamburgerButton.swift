import SwiftUI

struct HamburgerButton: ToolbarContent {
    @Binding var isDrawerOpen: Bool

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) { isDrawerOpen = true }
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.title3.bold())
                    .foregroundStyle(Theme.primaryText)
            }
            .buttonStyle(.plain)
        }
    }
}
