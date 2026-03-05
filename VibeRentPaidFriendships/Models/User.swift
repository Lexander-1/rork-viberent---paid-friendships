import Foundation

nonisolated enum UserRole: String, Codable, Sendable, CaseIterable {
    case host = "host"
    case customer = "customer"

    var title: String {
        switch self {
        case .host: return "Host"
        case .customer: return "Customer"
        }
    }

    var subtitle: String {
        switch self {
        case .host: return "Offer my time and earn money"
        case .customer: return "Book time to hang out"
        }
    }

    var icon: String {
        switch self {
        case .host: return "clock.badge.checkmark"
        case .customer: return "person.2.fill"
        }
    }
}

nonisolated enum HostSubscriptionTier: String, Codable, Sendable, CaseIterable {
    case free = "free"
    case pro = "pro"
    case elite = "elite"

    var title: String {
        switch self {
        case .free: return "Free"
        case .pro: return "Pro Host"
        case .elite: return "Elite Host"
        }
    }

    var price: String {
        switch self {
        case .free: return "Free"
        case .pro: return "$25/mo"
        case .elite: return "$50/mo"
        }
    }

    var monthlyPrice: Double {
        switch self {
        case .free: return 0
        case .pro: return 25
        case .elite: return 50
        }
    }

    var platformFeePercent: Double {
        switch self {
        case .free: return 0.25
        case .pro: return 0.15
        case .elite: return 0.10
        }
    }

    var feeLabel: String {
        switch self {
        case .free: return "25%"
        case .pro: return "15%"
        case .elite: return "10%"
        }
    }

    var maxDailyNotifications: Int {
        switch self {
        case .free: return 3
        case .pro: return 10
        case .elite: return 999
        }
    }
}

nonisolated enum AppTheme: String, Codable, Sendable, CaseIterable {
    case dark = "dark"
    case light = "light"
    case monotoneBlue = "monotone_blue"
    case monotoneRed = "monotone_red"
    case monotoneBrown = "monotone_brown"

    var title: String {
        switch self {
        case .dark: return "Dark"
        case .light: return "Light"
        case .monotoneBlue: return "Monotone Blue"
        case .monotoneRed: return "Monotone Red"
        case .monotoneBrown: return "Monotone Brown"
        }
    }
}

nonisolated struct User: Identifiable, Hashable, Codable, Sendable {
    let id: String
    var name: String
    var email: String
    var phone: String
    var bio: String
    var photoURL: String?
    var city: String
    var interests: [String]
    var isVerified: Bool
    var hasBackgroundCheck: Bool
    var isHost: Bool
    var hourlyRate: Double
    var rating: Double
    var reviewCount: Int
    var isFeatured: Bool
    var joinDate: Date
    var isAdmin: Bool
    var referralCode: String
    var referralCredits: Double
    var hasSubscription: Bool
    var subscriptionType: SubscriptionType?
    var role: UserRole
    var isGhostMode: Bool
    var latitude: Double?
    var longitude: Double?
    var hostTier: HostSubscriptionTier
    var appTheme: AppTheme
    var isAvailableNow: Bool
    var hasPriorityPass: Bool
    var hasInstantBoost: Bool
    var instantBoostExpiry: Date?
    var noShowCount: Int
    var isUnderReview: Bool
    var notificationsEnabled: Bool
    var proximityAlertsEnabled: Bool
    var locationSharingEnabled: Bool

    nonisolated enum SubscriptionType: String, Codable, Sendable, CaseIterable {
        case buyer = "buyer"
        case hostFeatured = "host_featured"
        case priorityPass = "priority_pass"

        var title: String {
            switch self {
            case .buyer: return "Premium Seeker"
            case .hostFeatured: return "Featured Host"
            case .priorityPass: return "Priority Pass"
            }
        }

        var price: String {
            switch self {
            case .buyer: return "$9.99/mo"
            case .hostFeatured: return "$19.99/mo"
            case .priorityPass: return "$14.99/mo"
            }
        }
    }
}

extension User {
    static let sampleUsers: [User] = [
        User(id: "1", name: "Sarah Chen", email: "sarah@example.com", phone: "+1234567890", bio: "Love coffee chats, hiking, and board games. NYC native who knows all the best spots!", photoURL: nil, city: "New York City", interests: ["Coffee", "Hiking", "Board Games", "Photography"], isVerified: true, hasBackgroundCheck: true, isHost: true, hourlyRate: 45, rating: 4.9, reviewCount: 127, isFeatured: true, joinDate: Date().addingTimeInterval(-86400 * 180), isAdmin: false, referralCode: "SARAH15", referralCredits: 45, hasSubscription: true, subscriptionType: .hostFeatured, role: .host, isGhostMode: false, latitude: 40.7128, longitude: -74.0060, hostTier: .elite, appTheme: .dark, isAvailableNow: true, hasPriorityPass: false, hasInstantBoost: false, instantBoostExpiry: nil, noShowCount: 0, isUnderReview: false, notificationsEnabled: true, proximityAlertsEnabled: true, locationSharingEnabled: true),
        User(id: "2", name: "Marcus Johnson", email: "marcus@example.com", phone: "+1234567891", bio: "Professional listener and amateur comedian. Let's grab lunch and swap stories!", photoURL: nil, city: "Los Angeles", interests: ["Comedy", "Food", "Music", "Movies"], isVerified: true, hasBackgroundCheck: false, isHost: true, hourlyRate: 35, rating: 4.7, reviewCount: 89, isFeatured: false, joinDate: Date().addingTimeInterval(-86400 * 120), isAdmin: false, referralCode: "MARC15", referralCredits: 15, hasSubscription: false, subscriptionType: nil, role: .host, isGhostMode: false, latitude: 34.0522, longitude: -118.2437, hostTier: .pro, appTheme: .dark, isAvailableNow: false, hasPriorityPass: false, hasInstantBoost: false, instantBoostExpiry: nil, noShowCount: 0, isUnderReview: false, notificationsEnabled: true, proximityAlertsEnabled: true, locationSharingEnabled: false),
        User(id: "3", name: "Priya Patel", email: "priya@example.com", phone: "+1234567892", bio: "Yoga instructor & bookworm. Looking to share mindful moments and deep conversations.", photoURL: nil, city: "Chicago", interests: ["Yoga", "Reading", "Meditation", "Art"], isVerified: true, hasBackgroundCheck: true, isHost: true, hourlyRate: 50, rating: 4.95, reviewCount: 203, isFeatured: true, joinDate: Date().addingTimeInterval(-86400 * 300), isAdmin: false, referralCode: "PRIYA15", referralCredits: 90, hasSubscription: true, subscriptionType: .hostFeatured, role: .host, isGhostMode: false, latitude: 41.8781, longitude: -87.6298, hostTier: .elite, appTheme: .dark, isAvailableNow: true, hasPriorityPass: false, hasInstantBoost: false, instantBoostExpiry: nil, noShowCount: 0, isUnderReview: false, notificationsEnabled: true, proximityAlertsEnabled: true, locationSharingEnabled: true),
        User(id: "4", name: "Jake Rivera", email: "jake@example.com", phone: "+1234567893", bio: "Tech nerd who loves exploring new neighborhoods. Always down for a walk and talk!", photoURL: nil, city: "Austin", interests: ["Tech", "Walking", "Coffee", "Gaming"], isVerified: true, hasBackgroundCheck: false, isHost: true, hourlyRate: 30, rating: 4.6, reviewCount: 45, isFeatured: false, joinDate: Date().addingTimeInterval(-86400 * 60), isAdmin: false, referralCode: "JAKE15", referralCredits: 0, hasSubscription: false, subscriptionType: nil, role: .host, isGhostMode: false, latitude: 30.2672, longitude: -97.7431, hostTier: .free, appTheme: .dark, isAvailableNow: false, hasPriorityPass: false, hasInstantBoost: false, instantBoostExpiry: nil, noShowCount: 0, isUnderReview: false, notificationsEnabled: true, proximityAlertsEnabled: false, locationSharingEnabled: false),
        User(id: "5", name: "Emma Wilson", email: "emma@example.com", phone: "+1234567894", bio: "Dog mom, brunch enthusiast, and great at karaoke. Let's hang!", photoURL: nil, city: "New York City", interests: ["Dogs", "Brunch", "Karaoke", "Shopping"], isVerified: true, hasBackgroundCheck: true, isHost: true, hourlyRate: 40, rating: 4.8, reviewCount: 156, isFeatured: false, joinDate: Date().addingTimeInterval(-86400 * 200), isAdmin: false, referralCode: "EMMA15", referralCredits: 30, hasSubscription: true, subscriptionType: .buyer, role: .host, isGhostMode: false, latitude: 40.7580, longitude: -73.9855, hostTier: .pro, appTheme: .dark, isAvailableNow: true, hasPriorityPass: false, hasInstantBoost: false, instantBoostExpiry: nil, noShowCount: 0, isUnderReview: false, notificationsEnabled: true, proximityAlertsEnabled: true, locationSharingEnabled: true),
        User(id: "6", name: "David Kim", email: "david@example.com", phone: "+1234567895", bio: "Museum hopper and street food connoisseur. Let me show you the hidden gems!", photoURL: nil, city: "San Jose", interests: ["Art", "Food", "Museums", "Travel"], isVerified: true, hasBackgroundCheck: false, isHost: true, hourlyRate: 55, rating: 4.85, reviewCount: 98, isFeatured: true, joinDate: Date().addingTimeInterval(-86400 * 150), isAdmin: false, referralCode: "DAVID15", referralCredits: 60, hasSubscription: true, subscriptionType: .hostFeatured, role: .host, isGhostMode: false, latitude: 37.3382, longitude: -121.8863, hostTier: .free, appTheme: .dark, isAvailableNow: false, hasPriorityPass: false, hasInstantBoost: true, instantBoostExpiry: Date().addingTimeInterval(86400), noShowCount: 0, isUnderReview: false, notificationsEnabled: true, proximityAlertsEnabled: true, locationSharingEnabled: false),
        User(id: "7", name: "Aisha Thompson", email: "aisha@example.com", phone: "+1234567896", bio: "Fitness coach by day, foodie by night. Let's hit a trail or try a new restaurant!", photoURL: nil, city: "Houston", interests: ["Fitness", "Food", "Hiking", "Cooking"], isVerified: true, hasBackgroundCheck: true, isHost: true, hourlyRate: 42, rating: 4.75, reviewCount: 67, isFeatured: false, joinDate: Date().addingTimeInterval(-86400 * 90), isAdmin: false, referralCode: "AISHA15", referralCredits: 15, hasSubscription: false, subscriptionType: nil, role: .host, isGhostMode: false, latitude: 29.7604, longitude: -95.3698, hostTier: .free, appTheme: .dark, isAvailableNow: false, hasPriorityPass: false, hasInstantBoost: false, instantBoostExpiry: nil, noShowCount: 0, isUnderReview: false, notificationsEnabled: true, proximityAlertsEnabled: false, locationSharingEnabled: false),
        User(id: "8", name: "Carlos Mendez", email: "carlos@example.com", phone: "+1234567897", bio: "Photographer and city explorer. I know the best sunset spots in town!", photoURL: nil, city: "San Diego", interests: ["Photography", "Travel", "Surfing", "Coffee"], isVerified: true, hasBackgroundCheck: false, isHost: true, hourlyRate: 38, rating: 4.65, reviewCount: 34, isFeatured: false, joinDate: Date().addingTimeInterval(-86400 * 45), isAdmin: false, referralCode: "CARL15", referralCredits: 0, hasSubscription: false, subscriptionType: nil, role: .host, isGhostMode: false, latitude: 32.7157, longitude: -117.1611, hostTier: .free, appTheme: .dark, isAvailableNow: false, hasPriorityPass: false, hasInstantBoost: false, instantBoostExpiry: nil, noShowCount: 0, isUnderReview: false, notificationsEnabled: true, proximityAlertsEnabled: false, locationSharingEnabled: false),
        User(id: "current", name: "Alex Morgan", email: "alex@example.com", phone: "+1234567899", bio: "New to VibeRent! Excited to meet cool people.", photoURL: nil, city: "New York City", interests: ["Music", "Coffee", "Travel"], isVerified: true, hasBackgroundCheck: false, isHost: false, hourlyRate: 0, rating: 4.5, reviewCount: 3, isFeatured: false, joinDate: Date(), isAdmin: false, referralCode: "ALEX15", referralCredits: 0, hasSubscription: false, subscriptionType: nil, role: .customer, isGhostMode: false, latitude: 40.7306, longitude: -73.9866, hostTier: .free, appTheme: .dark, isAvailableNow: false, hasPriorityPass: false, hasInstantBoost: false, instantBoostExpiry: nil, noShowCount: 0, isUnderReview: false, notificationsEnabled: true, proximityAlertsEnabled: true, locationSharingEnabled: true)
    ]

    static var currentUser: User { sampleUsers.last! }
}
