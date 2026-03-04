import SwiftUI

struct SubscriptionsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: User.SubscriptionType?
    var userRole: UserRole = .customer

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(Theme.secondaryText)

                        Text("Upgrade Your Vibe")
                            .font(.title2.bold())
                            .foregroundStyle(.white)

                        Text("Get more out of VibeRent")
                            .font(.subheadline)
                            .foregroundStyle(Theme.secondaryText)
                    }
                    .padding(.top, 16)

                    if userRole == .customer {
                        subscriptionCard(
                            type: .buyer,
                            icon: "sparkles",
                            features: [
                                "Unlimited bookings",
                                "Priority in Discover search",
                                "Ad-free social feed",
                                "Your profile posts get boosted"
                            ]
                        )
                    } else {
                        subscriptionCard(
                            type: .hostFeatured,
                            icon: "star.circle.fill",
                            features: [
                                "Pinned at top of city searches",
                                "Gold border on your profile",
                                "5x more profile views",
                                "Priority booking notifications",
                                "Earnings boost"
                            ]
                        )
                    }

                    VStack(spacing: 12) {
                        Text("One-Time Boost")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack(spacing: 16) {
                            Image(systemName: "bolt.fill")
                                .font(.title2)
                                .foregroundStyle(Theme.secondaryText)
                                .frame(width: 44)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Boost a Post — $4.99")
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.white)
                                Text("Show your post to 10,000 local users")
                                    .font(.caption)
                                    .foregroundStyle(Theme.secondaryText)
                            }

                            Spacer()

                            Button("Buy") { }
                                .font(.subheadline.bold())
                                .foregroundStyle(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Theme.buttonBackground)
                                .clipShape(.rect(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                )
                                .shadow(color: .white.opacity(0.08), radius: 6, x: 0, y: 0)
                        }
                        .padding(16)
                        .background(Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Theme.border, lineWidth: 1)
                        )
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 16)
            }
            .background(Theme.background)
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
                    .foregroundStyle(Theme.secondaryText)

                VStack(alignment: .leading, spacing: 2) {
                    Text(type.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text(type.price)
                        .font(.subheadline)
                        .foregroundStyle(Theme.secondaryText)
                }

                Spacer()

                if selectedPlan == type {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
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
                selectedPlan = type
            } label: {
                Text(selectedPlan == type ? "Selected" : "Subscribe")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(selectedPlan == type ? Color.green : Theme.buttonBackground)
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
                    .shadow(color: .white.opacity(0.08), radius: 6, x: 0, y: 0)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.border, lineWidth: 1)
        )
    }
}
