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
                            RecursiveCommentRow(
                                comment: comment,
                                currentUserId: currentUserId,
                                depth: 0,
                                onReply: { target in startReply(to: target) },
                                onDelete: { id in deleteComment(id) }
                            )
                        }
                    }
                    .padding(16)
                }

                Divider()
                    .background(Theme.border)

                if let replying = replyingTo {
                    HStack {
                        Text("Replying to @\(replying.authorName)")
                            .font(.caption)
                            .foregroundStyle(Theme.secondaryText)
                        Spacer()
                        Button {
                            replyingTo = nil
                            newComment = ""
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
                            .foregroundStyle(newComment.isEmpty ? Theme.secondaryText : .white)
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

    private func startReply(to target: FeedPost.Comment) {
        replyingTo = target
        newComment = "@\(target.authorName) "
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
            addReplyRecursive(to: parent.id, reply: comment, in: &localComments)
            feedViewModel?.addReplyRecursive(to: post.id, parentCommentId: parent.id, reply: comment)
            replyingTo = nil
        } else {
            localComments.append(comment)
            feedViewModel?.addComment(to: post.id, comment: comment)
        }
        newComment = ""
    }

    private func addReplyRecursive(to parentId: String, reply: FeedPost.Comment, in comments: inout [FeedPost.Comment]) {
        for i in comments.indices {
            if comments[i].id == parentId {
                comments[i].replies.append(reply)
                return
            }
            addReplyRecursive(to: parentId, reply: reply, in: &comments[i].replies)
        }
    }

    private func deleteComment(_ commentId: String) {
        removeCommentRecursive(commentId, from: &localComments)
        feedViewModel?.deleteComment(from: post.id, commentId: commentId)
    }

    private func removeCommentRecursive(_ commentId: String, from comments: inout [FeedPost.Comment]) {
        if comments.contains(where: { $0.id == commentId }) {
            comments.removeAll { $0.id == commentId }
            return
        }
        for i in comments.indices {
            removeCommentRecursive(commentId, from: &comments[i].replies)
        }
    }
}

struct RecursiveCommentRow: View {
    let comment: FeedPost.Comment
    let currentUserId: String
    let depth: Int
    let onReply: (FeedPost.Comment) -> Void
    let onDelete: (String) -> Void

    private var indent: CGFloat {
        min(CGFloat(depth) * 24, 72)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                AvatarView(name: comment.authorName, size: depth == 0 ? 32 : 24, userId: comment.authorId, isVerified: comment.authorIsVerified)

                VStack(alignment: .leading, spacing: 1) {
                    Text(comment.authorName)
                        .font(depth == 0 ? .subheadline.bold() : .caption.bold())
                        .foregroundStyle(Theme.primaryText)
                    Text(comment.createdAt, style: .relative)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }

                Spacer()

                if comment.authorId == currentUserId {
                    Button {
                        onDelete(comment.id)
                    } label: {
                        Image(systemName: "trash")
                            .font(.caption2)
                            .foregroundStyle(Theme.accentRed.opacity(0.7))
                    }
                }
            }

            Text(comment.text)
                .font(depth == 0 ? .subheadline : .caption)
                .foregroundStyle(.white.opacity(0.9))
                .padding(.leading, depth == 0 ? 40 : 32)

            Button {
                onReply(comment)
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "arrowshape.turn.up.left")
                        .font(.caption2)
                    Text("Reply")
                        .font(.caption.bold())
                }
                .foregroundStyle(Theme.secondaryText)
            }
            .padding(.leading, depth == 0 ? 40 : 32)

            if !comment.replies.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(comment.replies, id: \.id) { reply in
                        RecursiveCommentRow(
                            comment: reply,
                            currentUserId: currentUserId,
                            depth: depth + 1,
                            onReply: onReply,
                            onDelete: onDelete
                        )
                    }
                }
                .padding(.leading, 24)
                .padding(.top, 4)
            }
        }
        .padding(.leading, depth > 0 ? 0 : 0)
    }
}
