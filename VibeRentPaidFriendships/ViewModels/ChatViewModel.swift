import SwiftUI

@Observable
@MainActor
class ChatViewModel {
    var conversations: [Conversation] = Conversation.sampleConversations
    var messages: [String: [ChatMessage]] = ChatMessage.sampleMessages
    var deletedMessages: [String: [ChatMessage]] = [:]
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

    func deleteMessage(_ message: ChatMessage, in conversationId: String) {
        messages[conversationId]?.removeAll { $0.id == message.id }
        deletedMessages[conversationId, default: []].append(message)
    }

    func recoverMessage(_ message: ChatMessage, in conversationId: String) {
        deletedMessages[conversationId]?.removeAll { $0.id == message.id }
        messages[conversationId, default: []].append(message)
        messages[conversationId]?.sort { $0.createdAt < $1.createdAt }
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
