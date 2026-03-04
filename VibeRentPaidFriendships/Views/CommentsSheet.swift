import SwiftUI

struct CommentsSheet: View {
    let post: FeedPost
    var feedViewModel: FeedViewModel?
    @State private var newComment: String = ""
    @State private var localComments: [FeedPost.Comment] = []
    @State private var replyingTo: FeedPost.Comment?
    @Environment(\.dismiss) private var dismiss

    private let currentUserId = "current"

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        if localComments.isEmpty {
                            ContentUnavailableView("No Comments Yet", systemImage: "bubble.left", description: Text("Be the first to comment!"))
                                .padding(.top, 40)
                        }

                        ForEach(localComments, id: \.id) { comment in
                            CommentRow(
                                comment: comment,
                                currentUserId: currentUserId,
                                onReply: { replyingTo = comment },
                                onDelete: { deleteComment(comment.id) }
                            )
                        }
                    }
                    .padding(16)
                }

                Divider()
                    .background(Theme.border)

                if let replying = replyingTo {
                    HStack {
                        Text("Replying to \(replying.authorName)")
                            .font(.caption)
                            .foregroundStyle(Theme.secondaryText)
                        Spacer()
                        Button {
                            replyingTo = nil
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.caption)
                                .foregroundStyle(Theme.secondaryText)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }

                HStack(spacing: 12) {
                    TextField(replyingTo != nil ? "Write a reply..." : "Add a comment...", text: $newComment)
                        .padding(12)
                        .background(Theme.cardBackground)
                        .clipShape(.capsule)
                        .overlay(
                            Capsule().stroke(Theme.border, lineWidth: 1)
                        )

                    Button {
                        postComment()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundStyle(newComment.isEmpty ? Theme.secondaryText : Theme.accent)
                    }
                    .disabled(newComment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
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
        .onAppear {
            localComments = post.comments
        }
    }

    private func postComment() {
        let trimmed = newComment.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let comment = FeedPost.Comment(
            id: UUID().uuidString,
            authorId: currentUserId,
            authorName: "Alex Morgan",
            authorIsVerified: true,
            text: trimmed,
            createdAt: Date(),
            replies: []
        )

        if let parent = replyingTo {
            if let index = localComments.firstIndex(where: { $0.id == parent.id }) {
                localComments[index].replies.append(comment)
            }
            feedViewModel?.addReply(to: post.id, parentCommentId: parent.id, reply: comment)
            replyingTo = nil
        } else {
            localComments.append(comment)
            feedViewModel?.addComment(to: post.id, comment: comment)
        }
        newComment = ""
    }

    private func deleteComment(_ commentId: String) {
        localComments.removeAll { $0.id == commentId }
        for i in localComments.indices {
            localComments[i].replies.removeAll { $0.id == commentId }
        }
        feedViewModel?.deleteComment(from: post.id, commentId: commentId)
    }
}

struct CommentRow: View {
    let comment: FeedPost.Comment
    let currentUserId: String
    let onReply: () -> Void
    let onDelete: () -> Void

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

                Spacer()

                if comment.authorId == currentUserId {
                    Button {
                        onDelete()
                    } label: {
                        Image(systemName: "trash")
                            .font(.caption)
                            .foregroundStyle(Theme.dangerRed.opacity(0.7))
                    }
                }
            }

            Text(comment.text)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))
                .padding(.leading, 40)

            Button {
                onReply()
            } label: {
                Text("Reply")
                    .font(.caption.bold())
                    .foregroundStyle(Theme.secondaryText)
            }
            .padding(.leading, 40)

            if !comment.replies.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(comment.replies, id: \.id) { reply in
                        HStack(alignment: .top, spacing: 8) {
                            AvatarView(name: reply.authorName, size: 24, userId: reply.authorId, isVerified: reply.authorIsVerified)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(reply.authorName).font(.caption.bold()).foregroundStyle(.white)
                                Text(reply.text).font(.caption).foregroundStyle(.white.opacity(0.85))
                                Text(reply.createdAt, style: .relative)
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                            }
                            Spacer()
                            if reply.authorId == currentUserId {
                                Button {
                                    onDelete()
                                } label: {
                                    Image(systemName: "trash")
                                        .font(.caption2)
                                        .foregroundStyle(Theme.dangerRed.opacity(0.7))
                                }
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
