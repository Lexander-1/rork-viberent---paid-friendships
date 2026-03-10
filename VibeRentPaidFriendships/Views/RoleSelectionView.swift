import SwiftUI

struct RoleSelectionView: View {
    let onSelect: (UserRole) -> Void
    @State private var pressedRole: UserRole?

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Text("Vibe")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(Theme.primaryText)
                        Text("Rent")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(Theme.accentRed)
                    }

                    Text("Choose how you want to vibe")
                        .font(.title2.bold())
                        .foregroundStyle(Theme.primaryText)
                }

                VStack(spacing: 16) {
                    Button {
                        onSelect(.host)
                    } label: {
                        HStack(spacing: 16) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Theme.accentRed.opacity(0.12))
                                    .frame(width: 56, height: 56)

                                VStack(spacing: 2) {
                                    Image(systemName: "calendar.badge.clock")
                                        .font(.system(size: 18))
                                    Image(systemName: "dollarsign.circle")
                                        .font(.system(size: 12))
                                }
                                .foregroundStyle(Color(hex: 0xC77A7A))
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text("I'm a Host")
                                    .font(.title3.bold())
                                    .foregroundStyle(Theme.primaryText)
                                Text("Rent out your time and earn from real hangouts")
                                    .font(.subheadline)
                                    .foregroundStyle(Theme.secondaryText)
                                    .multilineTextAlignment(.leading)
                            }

                            Spacer(minLength: 0)

                            Image(systemName: "chevron.right")
                                .font(.subheadline.bold())
                                .foregroundStyle(Theme.secondaryText)
                        }
                        .padding(20)
                        .background(Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Theme.accentRed.opacity(0.25), lineWidth: 1)
                        )
                        .shadow(color: Theme.buttonGlow.opacity(pressedRole == .host ? 1 : 0), radius: 12, x: 0, y: 0)
                    }
                    .buttonStyle(ScaleTapStyle())
                    .sensoryFeedback(.impact(flexibility: .soft), trigger: pressedRole)
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in pressedRole = .host }
                            .onEnded { _ in pressedRole = nil }
                    )

                    Button {
                        onSelect(.customer)
                    } label: {
                        HStack(spacing: 16) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Theme.accentRed.opacity(0.12))
                                    .frame(width: 56, height: 56)

                                VStack(spacing: 2) {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 18))
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 12))
                                }
                                .foregroundStyle(Color(hex: 0xC77A7A))
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text("I'm a Customer")
                                    .font(.title3.bold())
                                    .foregroundStyle(Theme.primaryText)
                                Text("Book time with someone cool to beat loneliness")
                                    .font(.subheadline)
                                    .foregroundStyle(Theme.secondaryText)
                                    .multilineTextAlignment(.leading)
                            }

                            Spacer(minLength: 0)

                            Image(systemName: "chevron.right")
                                .font(.subheadline.bold())
                                .foregroundStyle(Theme.secondaryText)
                        }
                        .padding(20)
                        .background(Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Theme.accentRed.opacity(0.25), lineWidth: 1)
                        )
                        .shadow(color: Theme.buttonGlow.opacity(pressedRole == .customer ? 1 : 0), radius: 12, x: 0, y: 0)
                    }
                    .buttonStyle(ScaleTapStyle())
                    .sensoryFeedback(.impact(flexibility: .soft), trigger: pressedRole)
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in pressedRole = .customer }
                            .onEnded { _ in pressedRole = nil }
                    )
                }
                .padding(.horizontal, 24)

                Spacer()
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }
}
