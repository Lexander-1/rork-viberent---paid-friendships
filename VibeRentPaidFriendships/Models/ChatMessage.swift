import Foundation

nonisolated struct Conversation: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let participantIds: [String]
    let participantNames: [String]
    let bookingId: String
    var lastMessage: String
    var lastMessageAt: Date
    var unreadCount: Int
}

nonisolated struct ChatMessage: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let conversationId: String
    let senderId: String
    let senderName: String
    let text: String
    let createdAt: Date
    let isFlagged: Bool
}

extension Conversation {
    static let sampleConversations: [Conversation] = [
        Conversation(id: "conv1", participantIds: ["current", "1"], participantNames: ["Alex Morgan", "Sarah Chen"], bookingId: "b1", lastMessage: "Had such a great time! Let's do it again soon.", lastMessageAt: Date().addingTimeInterval(-3600), unreadCount: 1),
        Conversation(id: "conv2", participantIds: ["current", "5"], participantNames: ["Alex Morgan", "Emma Wilson"], bookingId: "b2", lastMessage: "See you at Central Park on Tuesday! I'll bring my dog.", lastMessageAt: Date().addingTimeInterval(-7200), unreadCount: 0)
    ]
}

extension ChatMessage {
    static let sampleMessages: [String: [ChatMessage]] = [
        "conv1": [
            ChatMessage(id: "m1", conversationId: "conv1", senderId: "1", senderName: "Sarah Chen", text: "Hey! So excited for our coffee chat tomorrow!", createdAt: Date().addingTimeInterval(-86400 * 2), isFlagged: false),
            ChatMessage(id: "m2", conversationId: "conv1", senderId: "current", senderName: "Alex Morgan", text: "Me too! I found this great spot on 5th Ave.", createdAt: Date().addingTimeInterval(-86400 * 2 + 300), isFlagged: false),
            ChatMessage(id: "m3", conversationId: "conv1", senderId: "1", senderName: "Sarah Chen", text: "Blue Bottle? I love that place! Perfect choice.", createdAt: Date().addingTimeInterval(-86400 * 2 + 600), isFlagged: false),
            ChatMessage(id: "m4", conversationId: "conv1", senderId: "current", senderName: "Alex Morgan", text: "That's the one! See you at 2pm?", createdAt: Date().addingTimeInterval(-86400 * 2 + 900), isFlagged: false),
            ChatMessage(id: "m5", conversationId: "conv1", senderId: "1", senderName: "Sarah Chen", text: "2pm works great! Can't wait.", createdAt: Date().addingTimeInterval(-86400 * 2 + 1200), isFlagged: false),
            ChatMessage(id: "m6", conversationId: "conv1", senderId: "1", senderName: "Sarah Chen", text: "Had such a great time! Let's do it again soon.", createdAt: Date().addingTimeInterval(-3600), isFlagged: false)
        ],
        "conv2": [
            ChatMessage(id: "m7", conversationId: "conv2", senderId: "5", senderName: "Emma Wilson", text: "Hey Alex! Looking forward to meeting up!", createdAt: Date().addingTimeInterval(-86400), isFlagged: false),
            ChatMessage(id: "m8", conversationId: "conv2", senderId: "current", senderName: "Alex Morgan", text: "Same here! Central Park sound good?", createdAt: Date().addingTimeInterval(-86400 + 300), isFlagged: false),
            ChatMessage(id: "m9", conversationId: "conv2", senderId: "5", senderName: "Emma Wilson", text: "See you at Central Park on Tuesday! I'll bring my dog.", createdAt: Date().addingTimeInterval(-7200), isFlagged: false)
        ]
    ]
}
