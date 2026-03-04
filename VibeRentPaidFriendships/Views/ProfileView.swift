import SwiftUI

struct ProfileView: View {
    @Binding var user: User
    let appViewModel: AppViewModel
    @State private var viewModel = ProfileViewModel()
    @State private var showSubscriptions: Bool = false
    @State private var showReferral: Bool = false
    @State private var showSettings: Bool = false
    @State private var showAdmin: Bool = false
    @State private var showLogoutAlert: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        AvatarView(
                            name: user.name,
                            size: 90,
                            userId: user.id,
                            isVerified: user.isVerified
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
                            .foregroundStyle(Theme.secondaryText)
                        }

                        HStack(spacing: 8) {
                            rolePill

                            if user.isVerified {
                                BadgePill(icon: "checkmark.seal.fill", text: "Verified", color: Theme.verifiedBlue)
                            }
                            if user.hasBackgroundCheck {
                                BadgePill(icon: "shield.checkmark.fill", text: "BG Check", color: .green)
                            }
                        }

                        Text(user.bio)
                            .font(.subheadline)
                            .foregroundStyle(Theme.secondaryText)
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
                        profileMenuItem(icon: "pencil.circle.fill", title: "Edit Profile", color: Theme.accent) {
                            viewModel.startEditing(user: user)
                        }

                        if !user.isVerified {
                            profileMenuItem(icon: "checkmark.seal.fill", title: "Get Verified", color: Theme.verifiedBlue) { }
                        }

                        if !user.hasBackgroundCheck {
                            profileMenuItem(icon: "shield.checkmark.fill", title: "Background Check — $9.99", color: .green) { }
                        }

                        profileMenuItem(icon: "crown.fill", title: "Subscriptions", color: Theme.accent) {
                            showSubscriptions = true
                        }

                        profileMenuItem(icon: "gift.fill", title: "Refer & Earn $15", color: Theme.accent) {
                            showReferral = true
                        }

                        profileMenuItem(icon: "gearshape.fill", title: "Settings", color: Theme.secondaryText) {
                            showSettings = true
                        }

                        if user.isAdmin {
                            profileMenuItem(icon: "lock.shield.fill", title: "Admin Dashboard", color: Theme.dangerRed) {
                                showAdmin = true
                            }
                        }
                    }
                    .padding(.horizontal, 16)

                    Button {
                        showLogoutAlert = true
                    } label: {
                        Text("Log Out")
                            .font(.subheadline)
                            .foregroundStyle(Theme.dangerRed)
                    }
                    .padding(.top, 8)

                    Spacer(minLength: 40)
                }
            }
            .background(Theme.background)
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
                SettingsView(appViewModel: appViewModel)
            }
            .fullScreenCover(isPresented: $showAdmin) {
                AdminDashboardView()
            }
            .alert("Log Out?", isPresented: $showLogoutAlert) {
                Button("Log Out", role: .destructive) {
                    appViewModel.logout()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("You will be signed out of your account.")
            }
        }
    }

    private var rolePill: some View {
        HStack(spacing: 4) {
            Image(systemName: user.role.icon)
                .font(.caption2)
            Text(user.role.title)
                .font(.caption2.bold())
        }
        .foregroundStyle(Theme.accent)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Theme.accent.opacity(0.15))
        .clipShape(.capsule)
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3.bold())
                .foregroundStyle(.white)
            Text(label)
                .font(.caption)
                .foregroundStyle(Theme.secondaryText)
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
