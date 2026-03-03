import Foundation

nonisolated struct FeedPost: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let authorId: String
    let authorName: String
    let authorPhotoURL: String?
    let authorIsVerified: Bool
    let taggedUserId: String
    let taggedUserName: String
    var caption: String
    var photoURLs: [String]
    var city: String
    var locationTag: String?
    var likeCount: Int
    var commentCount: Int
    var isLiked: Bool
    var isBoosted: Bool
    var createdAt: Date
    var comments: [Comment]

    nonisolated struct Comment: Identifiable, Hashable, Codable, Sendable {
        let id: String
        let authorId: String
        let authorName: String
        let authorIsVerified: Bool
        let text: String
        let createdAt: Date
        var replies: [Comment]
    }
}

extension FeedPost {
    static let samplePosts: [FeedPost] = [
        FeedPost(
            id: "p1", authorId: "1", authorName: "Sarah Chen", authorPhotoURL: nil, authorIsVerified: true,
            taggedUserId: "current", taggedUserName: "Alex Morgan",
            caption: "Had the best 2-hour coffee chat with @Alex Morgan — already booked round 2! The little cafe on 5th was perfect.",
            photoURLs: [], city: "New York City", locationTag: "Blue Bottle Coffee, NYC",
            likeCount: 47, commentCount: 5, isLiked: false, isBoosted: false,
            createdAt: Date().addingTimeInterval(-3600 * 2),
            comments: [
                .init(id: "c1", authorId: "5", authorName: "Emma Wilson", authorIsVerified: true, text: "Love that spot! Need to book Sarah too.", createdAt: Date().addingTimeInterval(-3600), replies: [
                    .init(id: "c1r1", authorId: "1", authorName: "Sarah Chen", authorIsVerified: true, text: "You should! Let's do a group hang next time!", createdAt: Date().addingTimeInterval(-1800), replies: [])
                ]),
                .init(id: "c2", authorId: "4", authorName: "Jake Rivera", authorIsVerified: true, text: "This is what VibeRent is all about!", createdAt: Date().addingTimeInterval(-2400), replies: [])
            ]
        ),
        FeedPost(
            id: "p2", authorId: "3", authorName: "Priya Patel", authorPhotoURL: nil, authorIsVerified: true,
            taggedUserId: "2", taggedUserName: "Marcus Johnson",
            caption: "Sunset yoga session with @Marcus Johnson was surprisingly amazing. Who knew a comedian could hold warrior pose for that long? 10/10 would vibe again.",
            photoURLs: [], city: "Chicago", locationTag: "Millennium Park",
            likeCount: 92, commentCount: 8, isLiked: true, isBoosted: true,
            createdAt: Date().addingTimeInterval(-86400),
            comments: [
                .init(id: "c3", authorId: "2", authorName: "Marcus Johnson", authorIsVerified: true, text: "My legs are STILL sore but it was worth it!", createdAt: Date().addingTimeInterval(-82800), replies: [])
            ]
        ),
        FeedPost(
            id: "p3", authorId: "5", authorName: "Emma Wilson", authorPhotoURL: nil, authorIsVerified: true,
            taggedUserId: "1", taggedUserName: "Sarah Chen",
            caption: "Dog park + brunch combo with @Sarah Chen. My golden retriever approved of her immediately. Best Sunday ever!",
            photoURLs: [], city: "New York City", locationTag: "Central Park Dog Run",
            likeCount: 134, commentCount: 12, isLiked: false, isBoosted: false,
            createdAt: Date().addingTimeInterval(-86400 * 2),
            comments: []
        ),
        FeedPost(
            id: "p4", authorId: "4", authorName: "Jake Rivera", authorPhotoURL: nil, authorIsVerified: true,
            taggedUserId: "6", taggedUserName: "David Kim",
            caption: "Explored the East Side art district with @David Kim today. Found 3 galleries I never knew existed. This app is honestly changing my weekends.",
            photoURLs: [], city: "Austin", locationTag: "East Austin Art District",
            likeCount: 78, commentCount: 6, isLiked: false, isBoosted: false,
            createdAt: Date().addingTimeInterval(-86400 * 3),
            comments: []
        ),
        FeedPost(
            id: "p5", authorId: "6", authorName: "David Kim", authorPhotoURL: nil, authorIsVerified: true,
            taggedUserId: "3", taggedUserName: "Priya Patel",
            caption: "Virtual book club session with @Priya Patel. We debated for 2 hours about the ending of 'Tomorrow, and Tomorrow, and Tomorrow'. Mind = blown.",
            photoURLs: [], city: "Virtual Only", locationTag: nil,
            likeCount: 56, commentCount: 4, isLiked: true, isBoosted: false,
            createdAt: Date().addingTimeInterval(-86400 * 4),
            comments: []
        ),
        FeedPost(
            id: "p6", authorId: "7", authorName: "Aisha Thompson", authorPhotoURL: nil, authorIsVerified: true,
            taggedUserId: "8", taggedUserName: "Carlos Mendez",
            caption: "Trail run with @Carlos Mendez through Hermann Park. He kept stopping to photograph everything but honestly the pictures turned out incredible!",
            photoURLs: [], city: "Houston", locationTag: "Hermann Park",
            likeCount: 63, commentCount: 3, isLiked: false, isBoosted: false,
            createdAt: Date().addingTimeInterval(-86400 * 5),
            comments: []
        )
    ]
}
