import SwiftUI

struct PlatonicAgreementView: View {
    let onAgree: () -> Void
    @State private var hasChecked: Bool = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                Image(systemName: "hand.raised.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(Theme.gradientStart)

                VStack(spacing: 16) {
                    Text("Platonic Only")
                        .font(.system(.largeTitle, weight: .bold))
                        .foregroundStyle(.white)

                    Text("VibeRent is a platonic-only marketplace for real friendship and companionship.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                VStack(alignment: .leading, spacing: 16) {
                    agreementRow("Zero tolerance for sexual or illegal activity")
                    agreementRow("All interactions must remain respectful and platonic")
                    agreementRow("Violations result in permanent account ban")
                    agreementRow("Users can report inappropriate behavior anytime")
                }
                .padding(24)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 16))
                .padding(.horizontal, 24)

                Spacer()

                VStack(spacing: 20) {
                    Button {
                        withAnimation(.snappy) { hasChecked.toggle() }
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: hasChecked ? "checkmark.square.fill" : "square")
                                .font(.title3)
                                .foregroundStyle(hasChecked ? Theme.gradientStart : .secondary)
                                .contentTransition(.symbolEffect(.replace))

                            Text("I agree to the Platonic Only terms and understand that any violations will result in immediate account termination.")
                                .font(.subheadline)
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding(.horizontal, 24)

                    GradientButton("Continue", icon: "checkmark.shield.fill") {
                        onAgree()
                    }
                    .padding(.horizontal, 24)
                    .opacity(hasChecked ? 1 : 0.4)
                    .disabled(!hasChecked)
                }
                .padding(.bottom, 32)
            }
        }
        .preferredColorScheme(.dark)
    }

    private func agreementRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .font(.body)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))
        }
    }
}
