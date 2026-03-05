import SwiftUI

struct SubscriptionsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: String?
    var userRole: UserRole = .customer
    @Binding var user: User

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
                        customerSubscriptions
                    } else {
                        hostSubscriptions
                    }

                    boostSection

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

    private var customerSubscriptions: some View {
        VStack(spacing: 16) {
            subscriptionCard(
                id: "premium_seeker",
                title: "Premium Seeker",
                price: "$9.99/mo",
                icon: "sparkles",
                features: [
                    "Unlimited bookings",
                    "Priority in Discover search",
                    "Ad-free social feed",
                    "Your profile posts get boosted"
                ]
            )

            subscriptionCard(
                id: "priority_pass",
                title: "Priority Pass",
                price: "$14.99/mo",
                icon: "bolt.shield.fill",
                features: [
                    "See Hosts 30 minutes earlier in Discover",
                    "Priority push notifications",
                    "Boosted profile visibility to Hosts",
                    "All Premium Seeker benefits included"
                ]
            )
        }
    }

    private var hostSubscriptions: some View {
        VStack(spacing: 16) {
            hostTierCard(
                tier: .pro,
                icon: "star.circle.fill",
                features: [
                    "Platform fee drops from 25% to 15%",
                    "Up to 10 proximity notifications/day",
                    "Priority in local search",
                    "Pro badge on profile"
                ]
            )

            hostTierCard(
                tier: .elite,
                icon: "crown.fill",
                features: [
                    "Platform fee drops from 25% to 10%",
                    "Unlimited priority notifications",
                    "Pinned at top of city searches",
                    "Elite badge + gold border on profile",
                    "5x more profile views"
                ]
            )
        }
    }

    private var boostSection: some View {
        VStack(spacing: 12) {
            Text("One-Time Purchases")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            if userRole == .host {
                boostItem(
                    icon: "bolt.fill",
                    title: "Instant Book Boost — $9.99",
                    description: "Appear at top of Discover for 24 hours",
                    action: {
                        user.hasInstantBoost = true
                        user.instantBoostExpiry = Date().addingTimeInterval(86400)
                    }
                )
            }

            boostItem(
                icon: "sparkle",
                title: "Boost a Post — $4.99",
                description: "Show your post to 10,000 local users",
                action: {}
            )

            boostItem(
                icon: "shield.checkmark.fill",
                title: "Safety Shield — $4.99/booking",
                description: "Extra photo + GPS verification at check-in",
                action: {}
            )
        }
    }

    private func subscriptionCard(id: String, title: String, price: String, icon: String, features: [String]) -> some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(Theme.secondaryText)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text(price)
                        .font(.subheadline)
                        .foregroundStyle(Theme.secondaryText)
                }

                Spacer()

                if selectedPlan == id {
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
                selectedPlan = id
                if id == "priority_pass" {
                    user.hasPriorityPass = true
                    user.subscriptionType = .priorityPass
                } else if id == "premium_seeker" {
                    user.subscriptionType = .buyer
                    user.hasSubscription = true
                }
            } label: {
                Text(selectedPlan == id ? "Selected" : "Subscribe")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(selectedPlan == id ? Color.green : Theme.buttonBackground)
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

    private func hostTierCard(tier: HostSubscriptionTier, icon: String, features: [String]) -> some View {
        let isSelected = user.hostTier == tier

        return VStack(spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(tier == .elite ? Theme.gold : Theme.secondaryText)

                VStack(alignment: .leading, spacing: 2) {
                    Text(tier.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text(tier.price)
                        .font(.subheadline)
                        .foregroundStyle(Theme.secondaryText)
                }

                Spacer()

                if isSelected {
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
                user.hostTier = tier
                selectedPlan = tier.rawValue
            } label: {
                Text(isSelected ? "Current Plan" : "Subscribe")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(isSelected ? Color.green : Theme.buttonBackground)
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
                .stroke(tier == .elite ? Theme.gold.opacity(0.3) : Theme.border, lineWidth: 1)
        )
    }

    private func boostItem(icon: String, title: String, description: String, action: @escaping () -> Void) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Theme.secondaryText)
                .frame(width: 44)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                Text(description)
                    .font(.caption)
                    .foregroundStyle(Theme.secondaryText)
            }

            Spacer()

            Button("Buy") { action() }
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
}
