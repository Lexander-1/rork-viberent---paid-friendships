import SwiftUI

@Observable
@MainActor
class CrewViewModel {
    var crews: [Crew] = Crew.sampleCrews
    var newMessageText: String = ""
    var replyingTo: CrewMessage?
    var isRecording: Bool = false
    var recordingSeconds: Int = 0

    func createCrew(name: String, interestTag: String?) {
        let crew = Crew(
            id: UUID().uuidString,
            name: name,
            photoURL: nil,
            interestTag: interestTag,
            creatorId: "current",
            memberIds: ["current"],
            memberNames: ["Alex Morgan"],
            messages: [],
            createdAt: Date()
        )
        crews.insert(crew, at: 0)
    }

    func deleteCrew(_ crewId: String) {
        crews.removeAll { $0.id == crewId }
    }

    func sendMessage(in crewId: String, senderId: String, senderName: String) {
        guard !newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let message = CrewMessage(
            id: UUID().uuidString,
            senderId: senderId,
            senderName: senderName,
            text: newMessageText,
            createdAt: Date(),
            type: .text,
            replyToId: replyingTo?.id,
            replyToText: replyingTo?.text,
            sharedPostId: nil,
            sharedPostAuthor: nil,
            sharedPostCaption: nil,
            bookingInfo: nil,
            voiceNoteDuration: nil
        )
        if let idx = crews.firstIndex(where: { $0.id == crewId }) {
            crews[idx].messages.append(message)
        }
        newMessageText = ""
        replyingTo = nil
    }

    func sendVoiceNote(in crewId: String, senderId: String, senderName: String, duration: Int) {
        let message = CrewMessage(
            id: UUID().uuidString,
            senderId: senderId,
            senderName: senderName,
            text: "Voice note (\(duration)s)",
            createdAt: Date(),
            type: .voiceNote,
            replyToId: nil,
            replyToText: nil,
            sharedPostId: nil,
            sharedPostAuthor: nil,
            sharedPostCaption: nil,
            bookingInfo: nil,
            voiceNoteDuration: duration
        )
        if let idx = crews.firstIndex(where: { $0.id == crewId }) {
            crews[idx].messages.append(message)
        }
    }

    func sharePost(in crewId: String, post: FeedPost, senderId: String, senderName: String) {
        let message = CrewMessage(
            id: UUID().uuidString,
            senderId: senderId,
            senderName: senderName,
            text: "Shared a post",
            createdAt: Date(),
            type: .sharedPost,
            replyToId: nil,
            replyToText: nil,
            sharedPostId: post.id,
            sharedPostAuthor: post.authorName,
            sharedPostCaption: post.caption,
            bookingInfo: nil,
            voiceNoteDuration: nil
        )
        if let idx = crews.firstIndex(where: { $0.id == crewId }) {
            crews[idx].messages.append(message)
        }
    }

    func sendBookingAlert(in crewId: String, senderId: String, senderName: String, bookedName: String, hours: Int, price: Int) {
        let message = CrewMessage(
            id: UUID().uuidString,
            senderId: senderId,
            senderName: senderName,
            text: "Booked \(bookedName) for \(hours)h @ $\(price)",
            createdAt: Date(),
            type: .bookingAlert,
            replyToId: nil,
            replyToText: nil,
            sharedPostId: nil,
            sharedPostAuthor: nil,
            sharedPostCaption: nil,
            bookingInfo: "Booked for \(hours)h @ $\(price)",
            voiceNoteDuration: nil
        )
        if let idx = crews.firstIndex(where: { $0.id == crewId }) {
            crews[idx].messages.append(message)
        }
    }

    func membersForCrew(_ crew: Crew) -> [User] {
        User.sampleUsers.filter { crew.memberIds.contains($0.id) }
    }
}
