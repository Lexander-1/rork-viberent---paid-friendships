import SwiftUI

struct ChatListView: View {
    @Bindable var viewModel: ChatViewModel
    @Binding var isDrawerOpen: Bool

    var body: some View {
        NavigationStack {
            List {
                if viewModel.conversations.isEmpty {
                    ContentUnavailableView(
                        "No Conversations",
                        systemImage: "bubble.left.and.bubble.right",
                        description: Text("Book a hang to start chatting!")
                    )
                } else {
                    ForEach(viewModel.conversations, id: \.id) { conversation in
                        NavigationLink(value: conversation) {
                            ConversationRow(conversation: conversation, viewModel: viewModel)
                        }
                        .listRowBackground(Theme.cardBackground)
                    }
                }
            }
            .listStyle(.plain)
            .background(Theme.background)
            .scrollContentBackground(.hidden)
            .navigationTitle("Messages")
            .toolbar {
                HamburgerButton(isDrawerOpen: $isDrawerOpen)
            }
            .navigationDestination(for: Conversation.self) { conversation in
                ChatDetailView(conversation: conversation, viewModel: viewModel)
            }
        }
    }
}

struct ConversationRow: View {
    let conversation: Conversation
    let viewModel: ChatViewModel

    private var otherName: String {
        viewModel.otherParticipantName(in: conversation, currentUserId: "current")
    }

    private var otherId: String {
        viewModel.otherParticipantId(in: conversation, currentUserId: "current")
    }

    var body: some View {
        HStack(spacing: 12) {
            AvatarView(name: otherName, size: 50, userId: otherId)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(otherName)
                        .font(.subheadline.bold())
                        .foregroundStyle(Theme.primaryText)
                    Spacer()
                    Text(conversation.lastMessageAt, style: .relative)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }

                Text(conversation.lastMessage)
                    .font(.subheadline)
                    .foregroundStyle(Theme.secondaryText)
                    .lineLimit(2)
            }

            if conversation.unreadCount > 0 {
                Text("\(conversation.unreadCount)")
                    .font(.caption2.bold())
                    .foregroundStyle(.white)
                    .frame(width: 20, height: 20)
                    .background(Theme.accent)
                    .clipShape(.circle)
            }
        }
        .padding(.vertical, 4)
    }
}
