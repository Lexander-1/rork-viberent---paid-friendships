import SwiftUI

struct RoleSelectionView: View {
    let onSelect: (UserRole) -> Void

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                Text("Choose your role")
                    .font(.title.bold())
                    .foregroundStyle(.white)

                VStack(spacing: 16) {
                    Button {
                        onSelect(.host)
                    } label: {
                        VStack(spacing: 8) {
                            Text("Host")
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                            Text("Offer my time and earn money")
                                .font(.subheadline)
                                .foregroundStyle(Theme.secondaryText)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(24)
                        .background(Theme.buttonBackground)
                        .clipShape(.rect(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                        .shadow(color: .white.opacity(0.08), radius: 6, x: 0, y: 0)
                    }

                    Button {
                        onSelect(.customer)
                    } label: {
                        VStack(spacing: 8) {
                            Text("Customer")
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                            Text("Book time to hang out")
                                .font(.subheadline)
                                .foregroundStyle(Theme.secondaryText)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(24)
                        .background(Theme.buttonBackground)
                        .clipShape(.rect(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                        .shadow(color: .white.opacity(0.08), radius: 6, x: 0, y: 0)
                    }
                }
                .padding(.horizontal, 24)

                Spacer()
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }
}
