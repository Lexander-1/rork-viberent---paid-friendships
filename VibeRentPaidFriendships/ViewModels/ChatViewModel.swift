import SwiftUI

@Observable
@MainActor
class ChatViewModel {
    var conversations: [Conversation] = Conversation.sampleConversations
    var messages: [String: [ChatMessage]] = ChatMessage.sampleMessages
    var newMessageText: String = ""

    func sendMessage(in conversationId: String, senderId: String, senderName: String) {
        guard !newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let message = ChatMessage(
            id: UUID().uuidString,
            conversationId: conversationId,
            senderId: senderId,
            senderName: senderName,
            text: newMessageText,
            createdAt: Date(),
            isFlagged: false
        )
        messages[conversationId, default: []].append(message)
        if let idx = conversations.firstIndex(where: { $0.id == conversationId }) {
            conversations[idx].lastMessage = newMessageText
            conversations[idx].lastMessageAt = Date()
        }
        newMessageText = ""
    }

    func otherParticipantName(in conversation: Conversation, currentUserId: String) -> String {
        if let idx = conversation.participantIds.firstIndex(where: { $0 != currentUserId }) {
            return conversation.participantNames[idx]
        }
        return conversation.participantNames.first ?? ""
    }

    func otherParticipantId(in conversation: Conversation, currentUserId: String) -> String {
        conversation.participantIds.first(where: { $0 != currentUserId }) ?? ""
    }
}
