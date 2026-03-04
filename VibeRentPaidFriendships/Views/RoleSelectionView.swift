import SwiftUI

struct RoleSelectionView: View {
    let onSelect: (UserRole) -> Void
    @State private var selectedRole: UserRole?
    @State private var appeared: Bool = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                VStack(spacing: 12) {
                    Text("Choose your path")
                        .font(.system(.largeTitle, weight: .bold))
                        .foregroundStyle(.white)

                    Text("You can switch roles anytime in Settings")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)

                VStack(spacing: 16) {
                    RoleCard(
                        role: .host,
                        isSelected: selectedRole == .host
                    ) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            selectedRole = .host
                        }
                    }
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 30)

                    RoleCard(
                        role: .seeker,
                        isSelected: selectedRole == .seeker
                    ) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            selectedRole = .seeker
                        }
                    }
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 40)
                }
                .padding(.horizontal, 24)

                Spacer()

                if let role = selectedRole {
                    GradientButton("Continue as \(role.title)", icon: "arrow.right") {
                        onSelect(role)
                    }
                    .padding(.horizontal, 24)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Spacer().frame(height: 40)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                appeared = true
            }
        }
    }
}

struct RoleCard: View {
    let role: UserRole
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            isSelected
                            ? AnyShapeStyle(LinearGradient(colors: [Theme.gradientStart, Theme.gradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing))
                            : AnyShapeStyle(Color.white.opacity(0.08))
                        )
                        .frame(width: 56, height: 56)

                    Image(systemName: role.icon)
                        .font(.title2)
                        .foregroundStyle(isSelected ? .white : .secondary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(role == .host ? "I want to offer my time" : "I want to book time")
                            .font(.headline)
                            .foregroundStyle(.white)

                        Text(role.title)
                            .font(.caption.bold())
                            .foregroundStyle(isSelected ? .white : Theme.gradientStart)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(
                                isSelected
                                ? Theme.gradientStart.opacity(0.3)
                                : Theme.gradientStart.opacity(0.15)
                            )
                            .clipShape(.capsule)
                    }

                    Text(role.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? Theme.gradientStart : Color.white.opacity(0.2))
            }
            .padding(20)
            .background(
                isSelected
                ? Theme.gradientStart.opacity(0.08)
                : Theme.cardBackground
            )
            .clipShape(.rect(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        isSelected
                        ? Theme.gradientStart.opacity(0.5)
                        : Color.clear,
                        lineWidth: 1.5
                    )
            }
        }
        .sensoryFeedback(.selection, trigger: isSelected)
    }
}
