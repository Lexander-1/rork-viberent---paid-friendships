import SwiftUI

struct ProfileView: View {
    @Binding var user: User
    let appViewModel: AppViewModel
    let feedViewModel: FeedViewModel
    @Binding var isDrawerOpen: Bool
    @State private var viewModel = ProfileViewModel()
    @State private var showSubscriptions: Bool = false
    @State private var showReferral: Bool = false
    @State private var showSettings: Bool = false
    @State private var showAdmin: Bool = false
    @State private var showLogoutAlert: Bool = false
    @State private var showCreatePost: Bool = false

    private var userPosts: [FeedPost] {
        feedViewModel.postsForUser(user.id)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    profileHeader
                    badgesRow
                    bioSection
                    statsRow

                    if !user.interests.isEmpty {
                        interestsSection
                    }

                    ghostModeSection

                    if user.role == .host {
                        hostTierInfo
                    }

                    menuSection
                    myPostsSection
                    logoutButton

                    Spacer(minLength: 40)
                }
            }
            .background(Theme.background)
            .navigationTitle("Profile")
            .toolbar {
                HamburgerButton(isDrawerOpen: $isDrawerOpen)
            }
            .sheet(isPresented: $viewModel.isEditing) {
                EditProfileSheet(viewModel: viewModel, user: $user)
            }
            .sheet(isPresented: $showSubscriptions) {
                SubscriptionsView(userRole: user.role, user: $user)
            }
            .sheet(isPresented: $showReferral) {
                ReferralView(user: user)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(appViewModel: appViewModel, user: $user)
            }
            .fullScreenCover(isPresented: $showAdmin) {
                AdminDashboardView()
            }
            .sheet(isPresented: $showCreatePost) {
                CreatePostView(feedViewModel: feedViewModel)
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

    private var profileHeader: some View {
        VStack(spacing: 12) {
            AvatarView(
                name: user.name,
                size: 80,
                userId: user.id,
                isVerified: user.isVerified
            )

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
        .padding(.top, 8)
    }

    private var badgesRow: some View {
        HStack(spacing: 8) {
            rolePill

            if user.isVerified {
                BadgePill(icon: "checkmark.seal.fill", text: "Verified", color: Theme.verifiedBlue)
            }
            if user.hasBackgroundCheck {
                BadgePill(icon: "shield.checkmark.fill", text: "BG Check", color: .green)
            }
            if user.role == .host && user.hostTier != .free {
                BadgePill(
                    icon: user.hostTier == .elite ? "crown.fill" : "star.circle.fill",
                    text: user.hostTier.title,
                    color: user.hostTier == .elite ? Theme.gold : Theme.secondaryText
                )
            }
            if user.hasPriorityPass {
                BadgePill(icon: "bolt.shield.fill", text: "Priority", color: .blue)
            }
        }
    }

    private var bioSection: some View {
        Text(user.bio)
            .font(.subheadline)
            .foregroundStyle(Theme.secondaryText)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
    }

    private var statsRow: some View {
        HStack(spacing: 32) {
            statItem(value: "\(user.reviewCount)", label: "Reviews")
            statItem(value: String(format: "%.1f", user.rating), label: "Rating")
            if user.role == .host {
                statItem(value: "$\(Int(user.hourlyRate))", label: "Per Hour")
            }
        }
    }

    private var interestsSection: some View {
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

    private var hostTierInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: user.hostTier == .elite ? "crown.fill" : user.hostTier == .pro ? "star.circle.fill" : "person.fill")
                    .foregroundStyle(user.hostTier == .elite ? Theme.gold : Theme.secondaryText)
                Text(user.hostTier == .free ? "Free Host" : user.hostTier.title)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                Spacer()
                Text("Fee: \(user.hostTier.feeLabel)")
                    .font(.caption.bold())
                    .foregroundStyle(Theme.secondaryText)
            }

            if user.hostTier == .free {
                Text("Upgrade to Pro or Elite to reduce platform fees")
                    .font(.caption)
                    .foregroundStyle(Theme.secondaryText)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(user.hostTier == .elite ? Theme.gold.opacity(0.3) : Theme.border, lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }

    private var menuSection: some View {
        VStack(spacing: 2) {
            profileMenuItem(icon: "pencil.circle.fill", title: "Edit Profile", color: Theme.secondaryText) {
                viewModel.startEditing(user: user)
            }

            if !user.isVerified {
                profileMenuItem(icon: "checkmark.seal.fill", title: "Get Verified", color: Theme.verifiedBlue) { }
            }

            if user.role == .host && !user.hasBackgroundCheck {
                profileMenuItem(icon: "shield.checkmark.fill", title: "Background Check — $9.99", color: .green) { }
            }

            profileMenuItem(icon: "crown.fill", title: "Subscriptions", color: Theme.secondaryText) {
                showSubscriptions = true
            }

            profileMenuItem(icon: "gift.fill", title: "Refer & Earn $25", color: Theme.secondaryText) {
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
    }

    private var myPostsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("My Posts")
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.horizontal, 16)

            Button {
                showCreatePost = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                    Text("Create Post")
                }
                .font(.subheadline.bold())
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Theme.buttonBackground)
                .clipShape(.rect(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
                .shadow(color: .white.opacity(0.08), radius: 6, x: 0, y: 0)
            }
            .padding(.horizontal, 16)

            if userPosts.isEmpty {
                Text("No posts yet. Share your first vibe!")
                    .font(.subheadline)
                    .foregroundStyle(Theme.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
            } else {
                ForEach(userPosts, id: \.id) { post in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(post.caption)
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .lineLimit(3)

                        HStack(spacing: 16) {
                            HStack(spacing: 4) {
                                Image(systemName: "heart.fill")
                                    .font(.caption2)
                                Text("\(post.likeCount)")
                                    .font(.caption)
                            }
                            .foregroundStyle(Theme.secondaryText)

                            HStack(spacing: 4) {
                                Image(systemName: "bubble.right")
                                    .font(.caption2)
                                Text("\(post.commentCount)")
                                    .font(.caption)
                            }
                            .foregroundStyle(Theme.secondaryText)

                            Spacer()

                            Text(post.createdAt, style: .relative)
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                    }
                    .padding(14)
                    .background(Theme.cardBackground)
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Theme.border, lineWidth: 1)
                    )
                    .padding(.horizontal, 16)
                }
            }
        }
    }

    private var ghostModeSection: some View {
        HStack(spacing: 14) {
            Image(systemName: "eye.slash.fill")
                .font(.body)
                .foregroundStyle(Theme.secondaryText)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text("Ghost Mode")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                Text("Hide your location from the map")
                    .font(.caption)
                    .foregroundStyle(Theme.secondaryText)
            }

            Spacer()

            Toggle("", isOn: $user.isGhostMode)
                .labelsHidden()
                .tint(Theme.secondaryText)
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.border, lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }

    private var logoutButton: some View {
        Button {
            showLogoutAlert = true
        } label: {
            Text("Log Out")
                .font(.subheadline)
                .foregroundStyle(Theme.dangerRed)
        }
        .padding(.top, 8)
    }

    private var rolePill: some View {
        HStack(spacing: 4) {
            Image(systemName: user.role.icon)
                .font(.caption2)
            Text(user.role.title)
                .font(.caption2.bold())
        }
        .foregroundStyle(Theme.secondaryText)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Theme.buttonBackground)
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
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.border, lineWidth: 1)
            )
        }
    }
}
