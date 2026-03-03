import Foundation

nonisolated struct Review: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let bookingId: String
    let reviewerId: String
    let reviewerName: String
    let revieweeId: String
    let rating: Int
    let text: String
    let createdAt: Date
}

extension Review {
    static let sampleReviews: [Review] = [
        Review(id: "r1", bookingId: "b1", reviewerId: "current", reviewerName: "Alex Morgan", revieweeId: "1", rating: 5, text: "Sarah is amazing! Such a great conversationalist and made me feel so welcome. The coffee spot she picked was perfect.", createdAt: Date().addingTimeInterval(-86400)),
        Review(id: "r2", bookingId: "b1", reviewerId: "1", reviewerName: "Sarah Chen", revieweeId: "current", rating: 5, text: "Alex was so fun to hang out with! Great energy and really interesting stories. Would definitely hang again!", createdAt: Date().addingTimeInterval(-82800)),
        Review(id: "r3", bookingId: "b3", reviewerId: "2", reviewerName: "Marcus Johnson", revieweeId: "3", rating: 5, text: "Priya's yoga session was incredible. I've never felt so centered. Plus the conversation after was just as good.", createdAt: Date().addingTimeInterval(-86400 * 4)),
        Review(id: "r4", bookingId: "b3", reviewerId: "3", reviewerName: "Priya Patel", revieweeId: "2", rating: 5, text: "Marcus kept me laughing the entire time while still being respectful of the practice. 10/10!", createdAt: Date().addingTimeInterval(-86400 * 4 + 3600))
    ]
}
