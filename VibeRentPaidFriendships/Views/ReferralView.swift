import SwiftUI

struct ReferralView: View {
    let user: User
    @Environment(\.dismiss) private var dismiss
    @State private var copied: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 16) {
                        Image(systemName: "gift.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(Theme.secondaryText)

                        Text("Refer & Earn")
                            .font(.title.bold())
                            .foregroundStyle(.white)

                        Text("Both you and your friend get $25 credit after their first completed booking!")
                            .font(.subheadline)
                            .foregroundStyle(Theme.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .padding(.top, 16)

                    VStack(spacing: 12) {
                        Text("Your Referral Code")
                            .font(.subheadline)
                            .foregroundStyle(Theme.secondaryText)

                        Text(user.referralCode)
                            .font(.system(.title, design: .monospaced).bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                            .background(Theme.cardBackground)
                            .clipShape(.rect(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Theme.border, lineWidth: 1)
                            )

                        Button {
                            UIPasteboard.general.string = user.referralCode
                            copied = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                copied = false
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: copied ? "checkmark" : "doc.on.doc")
                                Text(copied ? "Copied!" : "Copy Code")
                            }
                            .font(.subheadline.bold())
                            .foregroundStyle(Theme.secondaryText)
                        }
                    }

                    VStack(spacing: 12) {
                        Text("Your Earnings")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Credit Balance")
                                    .font(.subheadline)
                                    .foregroundStyle(Theme.secondaryText)
                                Text("$\(Int(user.referralCredits))")
                                    .font(.title.bold())
                                    .foregroundStyle(.white)
                            }
                            Spacer()
                        }
                        .padding(16)
                        .background(Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Theme.border, lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 16)

                    GradientButton("Share with Friends", icon: "square.and.arrow.up") { }
                        .padding(.horizontal, 16)

                    Spacer(minLength: 40)
                }
            }
            .background(Theme.background)
            .navigationTitle("Referral Program")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
