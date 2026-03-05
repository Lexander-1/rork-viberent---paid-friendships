import Foundation

nonisolated struct Booking: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let buyerId: String
    let hostId: String
    let hostName: String
    let buyerName: String
    let duration: SessionDuration
    let date: Date
    let totalPrice: Double
    let hostEarnings: Double
    let platformFee: Double
    var status: BookingStatus
    let city: String
    let meetingPlace: String?
    var isReviewedByBuyer: Bool
    var isReviewedByHost: Bool
    let createdAt: Date
    var hostTier: HostSubscriptionTier
    var confirmMeetCount: Int
    var hostConfirmedHere: Bool
    var buyerConfirmedHere: Bool
    var lastCheckIn: Date?
    var hasSafetyShield: Bool
    var hostConfirmMeetTaps: Int
    var buyerConfirmMeetTaps: Int
    var lastHostConfirmTap: Date?
    var lastBuyerConfirmTap: Date?
    var liveCheckInCount: Int

    nonisolated enum SessionDuration: String, Codable, Sendable, CaseIterable {
        case oneHour = "1_hour"
        case twoHours = "2_hours"
        case fourHours = "4_hours"
        case fullDay = "full_day"
        case custom = "custom"

        var label: String {
            switch self {
            case .oneHour: return "1 Hour"
            case .twoHours: return "2 Hours"
            case .fourHours: return "4 Hours"
            case .fullDay: return "Full Day (8 hrs)"
            case .custom: return "Custom"
            }
        }

        var hours: Int {
            switch self {
            case .oneHour: return 1
            case .twoHours: return 2
            case .fourHours: return 4
            case .fullDay: return 8
            case .custom: return 0
            }
        }
    }

    nonisolated enum BookingStatus: String, Codable, Sendable {
        case pending
        case confirmed
        case active
        case completed
        case cancelled
        case disputed
        case awaitingConfirmMeet
        case awaitingCheckIn
        case noShow
        case inProgress

        var label: String {
            switch self {
            case .pending: return "Pending"
            case .confirmed: return "Confirmed"
            case .active: return "In Progress"
            case .completed: return "Completed"
            case .cancelled: return "Cancelled"
            case .disputed: return "Disputed"
            case .awaitingConfirmMeet: return "Awaiting Confirm"
            case .awaitingCheckIn: return "Check In"
            case .noShow: return "No Show"
            case .inProgress: return "In Progress"
            }
        }

        var color: String {
            switch self {
            case .pending: return "orange"
            case .confirmed: return "blue"
            case .active, .inProgress: return "green"
            case .completed: return "purple"
            case .cancelled: return "red"
            case .disputed: return "red"
            case .awaitingConfirmMeet: return "orange"
            case .awaitingCheckIn: return "yellow"
            case .noShow: return "red"
            }
        }
    }

    static func calculatePrice(hourlyRate: Double, duration: SessionDuration, customHours: Int = 0, hostTier: HostSubscriptionTier = .free) -> (total: Double, hostEarnings: Double, platformFee: Double) {
        let hours = duration == .custom ? customHours : duration.hours
        let subtotal = hourlyRate * Double(hours)
        let feePercent = hostTier.platformFeePercent
        let platformFee = subtotal * feePercent
        let total = subtotal + platformFee
        let hostEarnings = subtotal
        return (total: total, hostEarnings: hostEarnings, platformFee: platformFee)
    }
}

extension Booking {
    static let sampleBookings: [Booking] = [
        Booking(id: "b1", buyerId: "current", hostId: "1", hostName: "Sarah Chen", buyerName: "Alex Morgan", duration: .twoHours, date: Date().addingTimeInterval(-86400), totalPrice: 99, hostEarnings: 90, platformFee: 9, status: .completed, city: "New York City", meetingPlace: "Blue Bottle Coffee", isReviewedByBuyer: true, isReviewedByHost: true, createdAt: Date().addingTimeInterval(-86400 * 3), hostTier: .elite, confirmMeetCount: 3, hostConfirmedHere: true, buyerConfirmedHere: true, lastCheckIn: nil, hasSafetyShield: false, hostConfirmMeetTaps: 3, buyerConfirmMeetTaps: 3, lastHostConfirmTap: nil, lastBuyerConfirmTap: nil, liveCheckInCount: 0),
        Booking(id: "b2", buyerId: "current", hostId: "5", hostName: "Emma Wilson", buyerName: "Alex Morgan", duration: .oneHour, date: Date().addingTimeInterval(86400 * 2), totalPrice: 46, hostEarnings: 40, platformFee: 6, status: .confirmed, city: "New York City", meetingPlace: "Central Park", isReviewedByBuyer: false, isReviewedByHost: false, createdAt: Date().addingTimeInterval(-3600), hostTier: .pro, confirmMeetCount: 0, hostConfirmedHere: false, buyerConfirmedHere: false, lastCheckIn: nil, hasSafetyShield: false, hostConfirmMeetTaps: 0, buyerConfirmMeetTaps: 0, lastHostConfirmTap: nil, lastBuyerConfirmTap: nil, liveCheckInCount: 0),
        Booking(id: "b3", buyerId: "2", hostId: "3", hostName: "Priya Patel", buyerName: "Marcus Johnson", duration: .fourHours, date: Date().addingTimeInterval(-86400 * 5), totalPrice: 220, hostEarnings: 200, platformFee: 20, status: .completed, city: "Chicago", meetingPlace: "Millennium Park", isReviewedByBuyer: true, isReviewedByHost: true, createdAt: Date().addingTimeInterval(-86400 * 7), hostTier: .elite, confirmMeetCount: 3, hostConfirmedHere: true, buyerConfirmedHere: true, lastCheckIn: nil, hasSafetyShield: true, hostConfirmMeetTaps: 3, buyerConfirmMeetTaps: 3, lastHostConfirmTap: nil, lastBuyerConfirmTap: nil, liveCheckInCount: 0)
    ]
}
