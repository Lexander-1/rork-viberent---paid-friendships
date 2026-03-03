import SwiftUI

struct SubscriptionsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: User.SubscriptionType?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(
                                LinearGradient(colors: [Theme.goldBorder, Theme.gradientEnd], startPoint: .top, endPoint: .bottom)
                            )

                        Text("Upgrade Your Vibe")
                            .font(.title2.bold())
                            .foregroundStyle(.white)

                        Text("Get more out of VibeRent")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 16)

                    subscriptionCard(
                        type: .buyer,
                        icon: "sparkles",
                        features: [
                            "Unlimited browsing",
                            "Priority in search results",
                            "Ad-free social feed",
                            "Exclusive badges"
                        ]
                    )

                    subscriptionCard(
                        type: .hostFeatured,
                        icon: "star.circle.fill",
                        features: [
                            "Pinned at top of city searches",
                            "Gold border on your profile",
                            "5x more profile views",
                            "Priority booking notifications",
                            "Featured badge"
                        ]
                    )

                    VStack(spacing: 12) {
                        Text("One-Time Boost")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack(spacing: 16) {
                            Image(systemName: "bolt.fill")
                                .font(.title2)
                                .foregroundStyle(Theme.gradientEnd)
                                .frame(width: 44)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Boost a Post — $4.99")
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.white)
                                Text("Show your post to 10,000 local users")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Button("Buy") { }
                                .font(.subheadline.bold())
                                .foregroundStyle(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Theme.gradientEnd)
                                .clipShape(.capsule)
                        }
                        .padding(16)
                        .background(Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 16))
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 16)
            }
            .background(Color.black)
            .navigationTitle("Subscriptions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func subscriptionCard(type: User.SubscriptionType, icon: String, features: [String]) -> some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(type == .hostFeatured ? Theme.goldBorder : Theme.gradientStart)

                VStack(alignment: .leading, spacing: 2) {
                    Text(type.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text(type.price)
                        .font(.subheadline)
                        .foregroundStyle(Theme.gradientStart)
                }

                Spacer()

                if selectedPlan == type {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Theme.gradientStart)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                ForEach(features, id: \.self) { feature in
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark")
                            .font(.caption2.bold())
                            .foregroundStyle(.green)
                        Text(feature)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.85))
                    }
                }
            }

            Button {
                withAnimation(.snappy) { selectedPlan = type }
            } label: {
                Text(selectedPlan == type ? "Selected" : "Subscribe")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(selectedPlan == type ? Color.green : Theme.gradientStart)
                    .clipShape(.capsule)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 16))
        .overlay {
            if type == .hostFeatured {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        LinearGradient(colors: [Theme.goldBorder, Theme.goldBorder.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 1.5
                    )
            }
        }
    }
}
