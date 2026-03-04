import SwiftUI

struct PlatonicAgreementView: View {
    let onAgree: () -> Void
    @State private var isChecked: Bool = false

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                Image(systemName: "shield.checkmark.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(Theme.secondaryText)

                VStack(spacing: 16) {
                    Text("Platonic Only")
                        .font(.title.bold())
                        .foregroundStyle(.white)

                    Text("VibeRent is a platonic companionship platform. All interactions must remain respectful and non-romantic. Any inappropriate behavior results in immediate account termination.")
                        .font(.body)
                        .foregroundStyle(Theme.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                Button {
                    isChecked.toggle()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                            .font(.title3)
                            .foregroundStyle(isChecked ? .white : Theme.secondaryText)
                        Text("I agree to platonic-only interactions")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                    }
                }

                GradientButton("Continue", icon: "arrow.right") {
                    onAgree()
                }
                .padding(.horizontal, 24)
                .opacity(isChecked ? 1 : 0.4)
                .disabled(!isChecked)

                Spacer()
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }
}
