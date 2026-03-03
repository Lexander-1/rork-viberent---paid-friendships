import SwiftUI

struct ProfileView: View {
    @Binding var user: User
    @State private var viewModel = ProfileViewModel()
    @State private var showSubscriptions: Bool = false
    @State private var showReferral: Bool = false
    @State private var showSettings: Bool = false
    @State private var showAdmin: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        AvatarView(
                            name: user.name,
                            size: 90,
                            userId: user.id,
                            isVerified: user.isVerified,
                            isFeatured: user.isFeatured
                        )

                        VStack(spacing: 6) {
                            Text(user.name)
                                .font(.title2.bold())
                                .foregroundStyle(.white)

                            HStack(spacing: 4) {
                                Image(systemName: "mappin")
                                    .font(.caption)
                                Text(user.city)
                                    .font(.subheadline)
                            }
                            .foregroundStyle(.secondary)
                        }

                        if user.isVerified || user.hasBackgroundCheck {
                            HStack(spacing: 8) {
                                if user.isVerified {
                                    BadgePill(icon: "checkmark.seal.fill", text: "Verified", color: Theme.verifiedBlue)
                                }
                                if user.hasBackgroundCheck {
                                    BadgePill(icon: "shield.checkmark.fill", text: "BG Check", color: .green)
                                }
                            }
                        }

                        Text(user.bio)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)

                        HStack(spacing: 32) {
                            statItem(value: "\(user.reviewCount)", label: "Reviews")
                            statItem(value: String(format: "%.1f", user.rating), label: "Rating")
                            if user.isHost {
                                statItem(value: "$\(Int(user.hourlyRate))", label: "Per Hour")
                            }
                        }
                    }
                    .padding(.top, 8)

                    if !user.interests.isEmpty {
                        FlowLayout(spacing: 8) {
                            ForEach(user.interests, id: \.self) { interest in
                                Text(interest)
                                    .font(.caption.bold())
                                    .foregroundStyle(.white.opacity(0.9))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.white.opacity(0.08))
                                    .clipShape(.capsule)
                            }
                        }
                        .padding(.horizontal, 16)
                    }

                    VStack(spacing: 2) {
                        profileMenuItem(icon: "pencil.circle.fill", title: "Edit Profile", color: Theme.gradientStart) {
                            viewModel.startEditing(user: user)
                        }

                        if !user.isVerified {
                            profileMenuItem(icon: "checkmark.seal.fill", title: "Get Verified", color: Theme.verifiedBlue) { }
                        }

                        if !user.hasBackgroundCheck {
                            profileMenuItem(icon: "shield.checkmark.fill", title: "Background Check — $9.99", color: .green) { }
                        }

                        profileMenuItem(icon: "crown.fill", title: "Subscriptions", color: Theme.goldBorder) {
                            showSubscriptions = true
                        }

                        profileMenuItem(icon: "gift.fill", title: "Refer & Earn $15", color: Theme.gradientEnd) {
                            showReferral = true
                        }

                        profileMenuItem(icon: "gearshape.fill", title: "Settings", color: .secondary) {
                            showSettings = true
                        }

                        if user.isAdmin {
                            profileMenuItem(icon: "lock.shield.fill", title: "Admin Dashboard", color: Theme.dangerRed) {
                                showAdmin = true
                            }
                        }
                    }
                    .padding(.horizontal, 16)

                    Spacer(minLength: 40)
                }
            }
            .background(Color.black)
            .navigationTitle("Profile")
            .sheet(isPresented: $viewModel.isEditing) {
                EditProfileSheet(viewModel: viewModel, user: $user)
            }
            .sheet(isPresented: $showSubscriptions) {
                SubscriptionsView()
            }
            .sheet(isPresented: $showReferral) {
                ReferralView(user: user)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .fullScreenCover(isPresented: $showAdmin) {
                AdminDashboardView()
            }
        }
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3.bold())
                .foregroundStyle(.white)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func profileMenuItem(icon: String, title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.body)
                    .foregroundStyle(color)
                    .frame(width: 28)

                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.white)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 12))
        }
    }
}
