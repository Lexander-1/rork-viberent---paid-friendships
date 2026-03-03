import SwiftUI

struct CommentsSheet: View {
    let post: FeedPost
    @State private var newComment: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        if post.comments.isEmpty {
                            ContentUnavailableView("No Comments Yet", systemImage: "bubble.left", description: Text("Be the first to comment!"))
                                .padding(.top, 40)
                        }

                        ForEach(post.comments, id: \.id) { comment in
                            CommentRow(comment: comment)
                        }
                    }
                    .padding(16)
                }

                Divider()

                HStack(spacing: 12) {
                    TextField("Add a comment...", text: $newComment)
                        .padding(12)
                        .background(Theme.cardBackground)
                        .clipShape(.capsule)

                    Button {
                        newComment = ""
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundStyle(newComment.isEmpty ? .secondary : Theme.gradientStart)
                    }
                    .disabled(newComment.isEmpty)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationContentInteraction(.scrolls)
        .preferredColorScheme(.dark)
    }
}

struct CommentRow: View {
    let comment: FeedPost.Comment

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                AvatarView(name: comment.authorName, size: 32, userId: comment.authorId, isVerified: comment.authorIsVerified)

                VStack(alignment: .leading, spacing: 1) {
                    Text(comment.authorName)
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                    Text(comment.createdAt, style: .relative)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }

            Text(comment.text)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))
                .padding(.leading, 40)

            if !comment.replies.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(comment.replies, id: \.id) { reply in
                        HStack(alignment: .top, spacing: 8) {
                            AvatarView(name: reply.authorName, size: 24, userId: reply.authorId, isVerified: reply.authorIsVerified)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(reply.authorName).font(.caption.bold()).foregroundStyle(.white)
                                Text(reply.text).font(.caption).foregroundStyle(.white.opacity(0.85))
                            }
                        }
                    }
                }
                .padding(.leading, 40)
                .padding(.top, 4)
            }
        }
    }
}
