import Foundation

nonisolated struct Crew: Identifiable, Hashable, Codable, Sendable {
    let id: String
    var name: String
    var photoURL: String?
    var interestTag: String?
    let creatorId: String
    var memberIds: [String]
    var memberNames: [String]
    var messages: [CrewMessage]
    var createdAt: Date

    var lastMessagePreview: String {
        messages.last?.text ?? "No messages yet"
    }

    var lastMessageDate: Date {
        messages.last?.createdAt ?? createdAt
    }
}

nonisolated struct CrewMessage: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let senderId: String
    let senderName: String
    let text: String
    let createdAt: Date
    var type: MessageType
    var replyToId: String?
    var replyToText: String?
    var replyToSenderName: String?
    var sharedPostId: String?
    var sharedPostAuthor: String?
    var sharedPostCaption: String?
    var bookingInfo: String?
    var voiceNoteDuration: Int?
    var imageURL: String?
    var fileName: String?
    var fileSize: String?

    nonisolated enum MessageType: String, Codable, Sendable, Hashable {
        case text
        case voiceNote
        case sharedPost
        case bookingAlert
        case photo
        case file
    }
}

extension Crew {
    static let sampleCrews: [Crew] = [
        Crew(
            id: "crew1",
            name: "NYC Coffee Lovers",
            photoURL: nil,
            interestTag: "Coffee",
            creatorId: "current",
            memberIds: ["current", "1", "5"],
            memberNames: ["Alex Morgan", "Sarah Chen", "Emma Wilson"],
            messages: [
                CrewMessage(id: "cm1", senderId: "1", senderName: "Sarah Chen", text: "Found an amazing new roaster in Brooklyn!", createdAt: Date().addingTimeInterval(-7200), type: .text, replyToId: nil, replyToText: nil, replyToSenderName: nil, sharedPostId: nil, sharedPostAuthor: nil, sharedPostCaption: nil, bookingInfo: nil, voiceNoteDuration: nil, imageURL: nil, fileName: nil, fileSize: nil),
                CrewMessage(id: "cm2", senderId: "5", senderName: "Emma Wilson", text: "Omg where?? I need to try it", createdAt: Date().addingTimeInterval(-3600), type: .text, replyToId: nil, replyToText: nil, replyToSenderName: nil, sharedPostId: nil, sharedPostAuthor: nil, sharedPostCaption: nil, bookingInfo: nil, voiceNoteDuration: nil, imageURL: nil, fileName: nil, fileSize: nil),
                CrewMessage(id: "cm3", senderId: "current", senderName: "Alex Morgan", text: "Let's all go this weekend!", createdAt: Date().addingTimeInterval(-1800), type: .text, replyToId: nil, replyToText: nil, replyToSenderName: nil, sharedPostId: nil, sharedPostAuthor: nil, sharedPostCaption: nil, bookingInfo: nil, voiceNoteDuration: nil, imageURL: nil, fileName: nil, fileSize: nil)
            ],
            createdAt: Date().addingTimeInterval(-86400 * 7)
        ),
        Crew(
            id: "crew2",
            name: "Fitness Squad",
            photoURL: nil,
            interestTag: "Fitness",
            creatorId: "7",
            memberIds: ["current", "7", "3"],
            memberNames: ["Alex Morgan", "Aisha Thompson", "Priya Patel"],
            messages: [
                CrewMessage(id: "cm4", senderId: "7", senderName: "Aisha Thompson", text: "Morning run tomorrow at 6am?", createdAt: Date().addingTimeInterval(-14400), type: .text, replyToId: nil, replyToText: nil, replyToSenderName: nil, sharedPostId: nil, sharedPostAuthor: nil, sharedPostCaption: nil, bookingInfo: nil, voiceNoteDuration: nil, imageURL: nil, fileName: nil, fileSize: nil),
                CrewMessage(id: "cm5", senderId: "3", senderName: "Priya Patel", text: "I'm in! Meeting at the park entrance?", createdAt: Date().addingTimeInterval(-10800), type: .text, replyToId: nil, replyToText: nil, replyToSenderName: nil, sharedPostId: nil, sharedPostAuthor: nil, sharedPostCaption: nil, bookingInfo: nil, voiceNoteDuration: nil, imageURL: nil, fileName: nil, fileSize: nil)
            ],
            createdAt: Date().addingTimeInterval(-86400 * 14)
        )
    ]
}
