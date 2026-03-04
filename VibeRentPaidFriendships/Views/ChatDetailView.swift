import SwiftUI

struct ChatDetailView: View {
    let conversation: Conversation
    @Bindable var viewModel: ChatViewModel
    @FocusState private var isInputFocused: Bool

    private var messages: [ChatMessage] {
        viewModel.messages[conversation.id] ?? []
    }

    private var otherName: String {
        viewModel.otherParticipantName(in: conversation, currentUserId: "current")
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "shield.checkmark.fill")
                    .font(.caption2)
                    .foregroundStyle(.green)
                Text("This chat is monitored for safety. Platonic interactions only.")
                    .font(.caption2)
                    .foregroundStyle(Theme.secondaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(Color.green.opacity(0.08))

            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(messages, id: \.id) { message in
                        MessageBubble(message: message, isFromCurrentUser: message.senderId == "current")
                    }
                }
                .padding(16)
            }
            .defaultScrollAnchor(.bottom)

            Divider().background(Color.white.opacity(0.1))

            HStack(spacing: 12) {
                TextField("Message...", text: $viewModel.newMessageText, axis: .vertical)
                    .lineLimit(1...4)
                    .focused($isInputFocused)
                    .padding(12)
                    .background(Theme.cardBackground)
                    .clipShape(.capsule)

                Button {
                    viewModel.sendMessage(in: conversation.id, senderId: "current", senderName: "Alex Morgan")
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundStyle(viewModel.newMessageText.isEmpty ? Theme.secondaryText : Theme.accent)
                }
                .disabled(viewModel.newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .sensoryFeedback(.impact(flexibility: .soft), trigger: messages.count)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial)
        }
        .background(Theme.background)
        .navigationTitle(otherName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Report Chat", systemImage: "flag") { }
                    Button("Share Location", systemImage: "location") { }
                    Button("Emergency SOS", systemImage: "sos", role: .destructive) { }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(Theme.secondaryText)
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    let isFromCurrentUser: Bool

    var body: some View {
        HStack {
            if isFromCurrentUser { Spacer(minLength: 60) }

            VStack(alignment: isFromCurrentUser ? .trailing : .leading, spacing: 4) {
                if !isFromCurrentUser {
                    Text(message.senderName)
                        .font(.caption2.bold())
                        .foregroundStyle(Theme.secondaryText)
                }

                Text(message.text)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(isFromCurrentUser ? Theme.accent : Color.white.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 18, style: .continuous))

                Text(message.createdAt, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            if !isFromCurrentUser { Spacer(minLength: 60) }
        }
    }
}
