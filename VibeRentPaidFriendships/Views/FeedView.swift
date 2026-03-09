import SwiftUI

struct FeedView: View {
    @Bindable var viewModel: FeedViewModel
    @Bindable var notificationsViewModel: NotificationsViewModel
    let users: [User]
    var currentUserRole: UserRole = .customer
    @Binding var isDrawerOpen: Bool
    @Binding var selectedPage: AppPage
    @State var themeManager: ThemeManager = ThemeManager.shared
    @State private var showNotifications: Bool = false
    @State private var showCommentsForPost: FeedPost?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.filteredPosts, id: \.id) { post in
                        FeedPostCard(
                            post: post,
                            onLike: { viewModel.toggleLike(for: post.id) },
                            users: users,
                            feedViewModel: viewModel
                        )

                        Divider()
                            .background(themeManager.border)
                    }

                    if viewModel.filteredPosts.isEmpty {
                        ContentUnavailableView(
                            "No Vibes Yet",
                            systemImage: "bubble.left.and.text.bubble.right",
                            description: Text("Be the first to share a vibe in \(viewModel.selectedCity)!")
                        )
                        .padding(.top, 60)
                    }
                }
                .padding(.top, 8)
            }
            .refreshable { await viewModel.refresh() }
            .background(themeManager.background)
            .navigationDestination(for: User.self) { user in
                HostProfileView(host: user, viewerRole: currentUserRole, posts: viewModel.postsForUser(user.id), feedViewModel: viewModel)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button {
                        viewModel.showCitySelector = true
                    } label: {
                        HStack(spacing: 6) {
                            Text(viewModel.selectedCity)
                                .font(.headline)
                                .foregroundStyle(themeManager.primaryText)

                            Image(systemName: "chevron.down")
                                .font(.caption.bold())
                                .foregroundStyle(themeManager.secondaryText)
                        }
                    }
                }

                HamburgerButton(isDrawerOpen: $isDrawerOpen)

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showNotifications = true
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bell.fill")
                                .font(.body)
                                .foregroundStyle(themeManager.secondaryText)

                            if notificationsViewModel.hasUnread {
                                Text("\(notificationsViewModel.unreadCount)")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundStyle(.white)
                                    .frame(minWidth: 15, minHeight: 15)
                                    .background(Theme.accentRed)
                                    .clipShape(Circle())
                                    .offset(x: 8, y: -8)
                            }
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $viewModel.showCitySelector) {
                CitySelectorView(selectedCity: viewModel.selectedCity) { city in
                    viewModel.selectCity(city)
                }
            }
            .sheet(isPresented: $viewModel.showCreatePost) {
                CreatePostView(feedViewModel: viewModel)
            }
            .sheet(isPresented: $showNotifications) {
                NotificationsView(viewModel: notificationsViewModel) { notification in
                    handleNotificationNavigation(notification)
                }
            }
            .sheet(item: $showCommentsForPost) { post in
                CommentsSheet(post: post, feedViewModel: viewModel)
            }
            .overlay(alignment: .bottomTrailing) {
                Button {
                    viewModel.showCreatePost = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                        .frame(width: 52, height: 52)
                        .background(Theme.buttonBackground)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                        .shadow(color: .white.opacity(0.08), radius: 6, x: 0, y: 0)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 24)
            }
        }
    }

    private func handleNotificationNavigation(_ notification: AppNotification) {
        switch notification.type {
        case .like, .reply, .mention:
            if let postId = notification.relatedPostId,
               let post = viewModel.posts.first(where: { $0.id == postId }) {
                showCommentsForPost = post
            }
        case .bookingConfirmed, .bookingCancelled, .bookingUpdate, .bookingReschedule:
            selectedPage = .chat
        case .newFollower:
            selectedPage = .profile
        }
    }
}

struct FeedPostCard: View {
    let post: FeedPost
    let onLike: () -> Void
    let users: [User]
    var feedViewModel: FeedViewModel?
    @State private var showComments: Bool = false
    @State private var showReport: Bool = false
    @State private var showShareSheet: Bool = false
    @State var themeManager: ThemeManager = ThemeManager.shared

    private var author: User? { users.first(where: { $0.id == post.authorId }) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                if let author {
                    NavigationLink(value: author) {
                        AvatarView(name: post.authorName, size: 40, userId: post.authorId, isVerified: post.authorIsVerified)
                    }
                } else {
                    AvatarView(name: post.authorName, size: 40, userId: post.authorId, isVerified: post.authorIsVerified)
                }

                VStack(alignment: .leading, spacing: 2) {
                    if let author {
                        NavigationLink(value: author) {
                            Text(post.authorName)
                                .font(.subheadline.bold())
                                .foregroundStyle(themeManager.primaryText)
                        }
                    } else {
                        Text(post.authorName)
                            .font(.subheadline.bold())
                            .foregroundStyle(themeManager.primaryText)
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "mappin")
                            .font(.caption2)
                        Text(post.locationTag ?? post.city)
                            .font(.caption)
                    }
                    .foregroundStyle(themeManager.secondaryText)
                }

                Spacer()

                if post.isBoosted {
                    Text("Boosted")
                        .font(.caption2.bold())
                        .foregroundStyle(Theme.gold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Theme.gold.opacity(0.15))
                        .clipShape(.capsule)
                }

                Menu {
                    Button("Report Post", systemImage: "flag") { showReport = true }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.body)
                        .foregroundStyle(themeManager.secondaryText)
                        .frame(width: 32, height: 32)
                }
            }
            .padding(.horizontal, 16)

            Text(post.caption)
                .font(.body)
                .foregroundStyle(themeManager.primaryText.opacity(0.95))
                .lineSpacing(4)
                .padding(.horizontal, 16)

            HStack(spacing: 0) {
                Button {
                    onLike()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: post.isLiked ? "heart.fill" : "heart")
                            .foregroundStyle(post.isLiked ? Theme.accentRed : themeManager.secondaryText)
                        Text("\(post.likeCount)")
                            .foregroundStyle(themeManager.secondaryText)
                    }
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }

                Button { showComments = true } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "bubble.right")
                        Text("\(post.commentCount)")
                    }
                    .font(.subheadline)
                    .foregroundStyle(themeManager.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }

                Button {
                    showShareSheet = true
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share")
                    }
                    .font(.subheadline)
                    .foregroundStyle(themeManager.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
            }
            .padding(.horizontal, 8)

            Text(post.createdAt, style: .relative)
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .padding(.horizontal, 16)
                .padding(.bottom, 4)
        }
        .padding(.vertical, 12)
        .background(boostedBackground)
        .sheet(isPresented: $showComments) {
            CommentsSheet(post: post, feedViewModel: feedViewModel)
        }
        .sheet(isPresented: $showShareSheet) {
            SharePostSheet(post: post)
        }
        .alert("Report Post", isPresented: $showReport) {
            Button("Report", role: .destructive) { }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This post will be flagged for review by our moderation team.")
        }
    }

    @ViewBuilder
    private var boostedBackground: some View {
        Color.clear
    }
}

struct SharePostSheet: View {
    let post: FeedPost
    @Environment(\.dismiss) private var dismiss
    @State private var linkCopied: Bool = false

    private var shareLink: String {
        "https://viberent.app/post/\(post.id)"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text(post.caption)
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .lineLimit(3)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("by \(post.authorName)")
                        .font(.caption)
                        .foregroundStyle(Theme.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(16)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.border, lineWidth: 1)
                )

                Button {
                    UIPasteboard.general.string = shareLink
                    linkCopied = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        linkCopied = false
                    }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: linkCopied ? "checkmark.circle.fill" : "link")
                            .font(.body)
                        Text(linkCopied ? "Link Copied!" : "Copy Link")
                            .font(.subheadline.bold())
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(linkCopied ? Color.green : Theme.buttonBackground)
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
                    .shadow(color: .white.opacity(0.08), radius: 6, x: 0, y: 0)
                }

                Button {
                    let items: [Any] = [shareLink]
                    let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let rootVC = windowScene.windows.first?.rootViewController {
                        rootVC.present(activityVC, animated: true)
                    }
                    dismiss()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.body)
                        Text("Share via...")
                            .font(.subheadline.bold())
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Theme.cardBackground)
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Theme.border, lineWidth: 1)
                    )
                }

                Spacer()
            }
            .padding(16)
            .background(Theme.background)
            .navigationTitle("Share Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .preferredColorScheme(.dark)
    }
}
