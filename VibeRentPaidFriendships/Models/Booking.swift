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
    let status: BookingStatus
    let city: String
    let meetingPlace: String?
    let isReviewedByBuyer: Bool
    let isReviewedByHost: Bool
    let createdAt: Date

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

        var label: String {
            switch self {
            case .pending: return "Pending"
            case .confirmed: return "Confirmed"
            case .active: return "In Progress"
            case .completed: return "Completed"
            case .cancelled: return "Cancelled"
            case .disputed: return "Disputed"
            }
        }

        var color: String {
            switch self {
            case .pending: return "orange"
            case .confirmed: return "blue"
            case .active: return "green"
            case .completed: return "purple"
            case .cancelled: return "red"
            case .disputed: return "red"
            }
        }
    }

    static func calculatePrice(hourlyRate: Double, duration: SessionDuration, customHours: Int = 0) -> (total: Double, hostEarnings: Double, platformFee: Double) {
        let hours = duration == .custom ? customHours : duration.hours
        let hostEarnings = hourlyRate * Double(hours)
        let platformFee = hostEarnings * 0.25
        let total = hostEarnings + platformFee
        return (total: total, hostEarnings: hostEarnings, platformFee: platformFee)
    }
}

extension Booking {
    static let sampleBookings: [Booking] = [
        Booking(id: "b1", buyerId: "current", hostId: "1", hostName: "Sarah Chen", buyerName: "Alex Morgan", duration: .twoHours, date: Date().addingTimeInterval(-86400), totalPrice: 90, hostEarnings: 67.5, platformFee: 22.5, status: .completed, city: "New York City", meetingPlace: "Blue Bottle Coffee", isReviewedByBuyer: true, isReviewedByHost: true, createdAt: Date().addingTimeInterval(-86400 * 3)),
        Booking(id: "b2", buyerId: "current", hostId: "5", hostName: "Emma Wilson", buyerName: "Alex Morgan", duration: .oneHour, date: Date().addingTimeInterval(86400 * 2), totalPrice: 40, hostEarnings: 30, platformFee: 10, status: .confirmed, city: "New York City", meetingPlace: "Central Park", isReviewedByBuyer: false, isReviewedByHost: false, createdAt: Date().addingTimeInterval(-3600)),
        Booking(id: "b3", buyerId: "2", hostId: "3", hostName: "Priya Patel", buyerName: "Marcus Johnson", duration: .fourHours, date: Date().addingTimeInterval(-86400 * 5), totalPrice: 200, hostEarnings: 150, platformFee: 50, status: .completed, city: "Chicago", meetingPlace: "Millennium Park", isReviewedByBuyer: true, isReviewedByHost: true, createdAt: Date().addingTimeInterval(-86400 * 7))
    ]
}
