import SwiftUI

struct FeedView: View {
    @Bindable var viewModel: FeedViewModel
    let users: [User]
    @State private var likeAnimationPostId: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.filteredPosts, id: \.id) { post in
                        FeedPostCard(
                            post: post,
                            likeAnimationPostId: $likeAnimationPostId,
                            onLike: { viewModel.toggleLike(for: post.id) },
                            users: users
                        )
                        .padding(.bottom, 8)

                        Divider()
                            .background(Color.white.opacity(0.06))
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
            .background(Color.black)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        viewModel.showCitySelector = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "line.3.horizontal")
                                .font(.body.bold())
                                .foregroundStyle(.white)

                            Text(viewModel.selectedCity)
                                .font(.headline)
                                .foregroundStyle(.white)

                            Image(systemName: "chevron.down")
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showCreatePost = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundStyle(Theme.gradientStart)
                    }
                }
            }
            .fullScreenCover(isPresented: $viewModel.showCitySelector) {
                CitySelectorView(selectedCity: viewModel.selectedCity) { city in
                    viewModel.selectCity(city)
                }
            }
            .sheet(isPresented: $viewModel.showCreatePost) {
                CreatePostView()
            }
        }
    }
}

struct FeedPostCard: View {
    let post: FeedPost
    @Binding var likeAnimationPostId: String?
    let onLike: () -> Void
    let users: [User]
    @State private var showComments: Bool = false
    @State private var showReport: Bool = false
    @State private var heartScale: CGFloat = 1.0

    private var author: User? { users.first(where: { $0.id == post.authorId }) }
    private var taggedUser: User? { users.first(where: { $0.id == post.taggedUserId }) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                AvatarView(name: post.authorName, size: 44, userId: post.authorId, isVerified: post.authorIsVerified)

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text(post.authorName)
                            .font(.subheadline.bold())
                            .foregroundStyle(.white)
                    }

                    HStack(spacing: 4) {
                        if let locationTag = post.locationTag {
                            Image(systemName: "mappin")
                                .font(.caption2)
                            Text(locationTag)
                                .font(.caption)
                        } else {
                            Image(systemName: "mappin")
                                .font(.caption2)
                            Text(post.city)
                                .font(.caption)
                        }
                    }
                    .foregroundStyle(.secondary)
                }

                Spacer()

                if post.isBoosted {
                    Label("Boosted", systemImage: "bolt.fill")
                        .font(.caption2.bold())
                        .foregroundStyle(Theme.gradientEnd)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Theme.gradientEnd.opacity(0.15))
                        .clipShape(.capsule)
                }

                Menu {
                    Button("Report Post", systemImage: "flag") { showReport = true }
                    Button("Share", systemImage: "square.and.arrow.up") { }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .frame(width: 32, height: 32)
                }
            }
            .padding(.horizontal, 16)

            Text(post.caption)
                .font(.body)
                .foregroundStyle(.white.opacity(0.95))
                .lineSpacing(4)
                .padding(.horizontal, 16)

            if let tagged = taggedUser {
                NavigationLink(value: tagged) {
                    HStack(spacing: 8) {
                        AvatarView(name: tagged.name, size: 28, userId: tagged.id, isVerified: tagged.isVerified)
                        VStack(alignment: .leading, spacing: 1) {
                            Text("with \(tagged.name)")
                                .font(.caption.bold())
                                .foregroundStyle(.white.opacity(0.9))
                            if tagged.isHost {
                                Text("Book this Vibe")
                                    .font(.caption2.bold())
                                    .foregroundStyle(Theme.gradientStart)
                            }
                        }
                        Spacer()
                        if tagged.isHost {
                            Image(systemName: "calendar.badge.plus")
                                .font(.subheadline)
                                .foregroundStyle(Theme.gradientStart)
                        }
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.05))
                    .clipShape(.rect(cornerRadius: 12))
                }
                .padding(.horizontal, 16)
            }

            HStack(spacing: 0) {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        heartScale = 1.3
                    }
                    onLike()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            heartScale = 1.0
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: post.isLiked ? "heart.fill" : "heart")
                            .foregroundStyle(post.isLiked ? .red : .secondary)
                            .scaleEffect(heartScale)
                            .contentTransition(.symbolEffect(.replace))
                        Text("\(post.likeCount)")
                            .foregroundStyle(.secondary)
                    }
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
                .sensoryFeedback(.impact(flexibility: .soft), trigger: post.isLiked)

                Button { showComments = true } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "bubble.right")
                        Text("\(post.commentCount)")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }

                Button { } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
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
        .sheet(isPresented: $showComments) {
            CommentsSheet(post: post)
        }
        .alert("Report Post", isPresented: $showReport) {
            Button("Report", role: .destructive) { }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This post will be flagged for review by our moderation team.")
        }
        .navigationDestination(for: User.self) { user in
            HostProfileView(host: user)
        }
    }
}
