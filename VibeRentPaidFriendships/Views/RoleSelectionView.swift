import SwiftUI

struct RoleSelectionView: View {
    let onSelect: (UserRole) -> Void

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 48) {
                Spacer()

                Text("Choose your role")
                    .font(.system(.title, weight: .bold))
                    .foregroundStyle(.white)

                HStack(spacing: 16) {
                    RoleCard(role: .host, onSelect: onSelect)
                    RoleCard(role: .customer, onSelect: onSelect)
                }
                .padding(.horizontal, 24)

                Spacer()
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct RoleCard: View {
    let role: UserRole
    let onSelect: (UserRole) -> Void

    var body: some View {
        Button {
            onSelect(role)
        } label: {
            VStack(spacing: 16) {
                Image(systemName: role.icon)
                    .font(.system(size: 32))
                    .foregroundStyle(Theme.accent)

                Text(role.title)
                    .font(.headline)
                    .foregroundStyle(.white)

                Text(role.subtitle)
                    .font(.caption)
                    .foregroundStyle(Theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.border, lineWidth: 1)
            )
        }
    }
}
