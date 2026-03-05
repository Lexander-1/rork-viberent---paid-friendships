import Foundation

nonisolated enum NotificationType: String, Codable, Sendable {
    case like
    case reply
    case bookingUpdate
    case bookingConfirmed
    case bookingCancelled
    case bookingReschedule
    case newFollower
    case mention

    var icon: String {
        switch self {
        case .like: return "heart.fill"
        case .reply: return "arrowshape.turn.up.left.fill"
        case .bookingUpdate: return "calendar.badge.clock"
        case .bookingConfirmed: return "checkmark.circle.fill"
        case .bookingCancelled: return "xmark.circle.fill"
        case .bookingReschedule: return "arrow.triangle.2.circlepath"
        case .newFollower: return "person.badge.plus"
        case .mention: return "at"
        }
    }
}

nonisolated struct AppNotification: Identifiable, Codable, Sendable {
    let id: String
    let type: NotificationType
    let fromUserId: String
    let fromUserName: String
    let fromUserIsVerified: Bool
    let message: String
    let relatedPostId: String?
    let relatedBookingId: String?
    var isRead: Bool
    let createdAt: Date
}

extension AppNotification {
    static let sampleNotifications: [AppNotification] = [
        AppNotification(id: "n1", type: .like, fromUserId: "1", fromUserName: "Sarah Chen", fromUserIsVerified: true, message: "liked your post", relatedPostId: "p3", relatedBookingId: nil, isRead: false, createdAt: Date().addingTimeInterval(-300)),
        AppNotification(id: "n2", type: .like, fromUserId: "5", fromUserName: "Emma Wilson", fromUserIsVerified: true, message: "liked your post", relatedPostId: "p3", relatedBookingId: nil, isRead: false, createdAt: Date().addingTimeInterval(-600)),
        AppNotification(id: "n3", type: .reply, fromUserId: "4", fromUserName: "Jake Rivera", fromUserIsVerified: true, message: "replied to your comment: \"This is what VibeRent is all about!\"", relatedPostId: "p1", relatedBookingId: nil, isRead: false, createdAt: Date().addingTimeInterval(-1800)),
        AppNotification(id: "n4", type: .bookingConfirmed, fromUserId: "5", fromUserName: "Emma Wilson", fromUserIsVerified: true, message: "confirmed your booking for 2 Hours on Dec 15", relatedPostId: nil, relatedBookingId: "b2", isRead: false, createdAt: Date().addingTimeInterval(-3600)),
        AppNotification(id: "n5", type: .reply, fromUserId: "1", fromUserName: "Sarah Chen", fromUserIsVerified: true, message: "replied to your post: \"You should! Let's do a group hang next time!\"", relatedPostId: "p1", relatedBookingId: nil, isRead: true, createdAt: Date().addingTimeInterval(-7200)),
        AppNotification(id: "n6", type: .bookingUpdate, fromUserId: "3", fromUserName: "Priya Patel", fromUserIsVerified: true, message: "requested to reschedule your booking", relatedPostId: nil, relatedBookingId: "b3", isRead: true, createdAt: Date().addingTimeInterval(-14400)),
        AppNotification(id: "n7", type: .like, fromUserId: "6", fromUserName: "David Kim", fromUserIsVerified: true, message: "liked your post", relatedPostId: "p5", relatedBookingId: nil, isRead: true, createdAt: Date().addingTimeInterval(-18000)),
        AppNotification(id: "n8", type: .bookingCancelled, fromUserId: "2", fromUserName: "Marcus Johnson", fromUserIsVerified: true, message: "cancelled the booking for Dec 10", relatedPostId: nil, relatedBookingId: "b1", isRead: true, createdAt: Date().addingTimeInterval(-86400)),
        AppNotification(id: "n9", type: .like, fromUserId: "7", fromUserName: "Aisha Thompson", fromUserIsVerified: true, message: "liked your post", relatedPostId: "p3", relatedBookingId: nil, isRead: true, createdAt: Date().addingTimeInterval(-86400 * 2)),
        AppNotification(id: "n10", type: .reply, fromUserId: "3", fromUserName: "Priya Patel", fromUserIsVerified: true, message: "replied to your comment: \"Love this vibe!\"", relatedPostId: "p2", relatedBookingId: nil, isRead: true, createdAt: Date().addingTimeInterval(-86400 * 2)),
        AppNotification(id: "n11", type: .mention, fromUserId: "8", fromUserName: "Carlos Mendez", fromUserIsVerified: true, message: "mentioned you in a comment", relatedPostId: "p6", relatedBookingId: nil, isRead: true, createdAt: Date().addingTimeInterval(-86400 * 3))
    ]
}
