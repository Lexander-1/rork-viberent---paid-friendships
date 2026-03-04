import SwiftUI

@Observable
@MainActor
class BookingViewModel {
    var bookings: [Booking] = Booking.sampleBookings
    var selectedDuration: Booking.SessionDuration = .oneHour
    var customHours: Int = 3
    var selectedDate: Date = Date().addingTimeInterval(86400)
    var showPlatonicConfirmation: Bool = false
    var showBookingSuccess: Bool = false
    var isProcessing: Bool = false

    func calculatePrice(for host: User) -> (total: Double, hostEarnings: Double, platformFee: Double) {
        Booking.calculatePrice(hourlyRate: host.hourlyRate, duration: selectedDuration, customHours: customHours)
    }

    var effectiveHours: Int {
        selectedDuration == .custom ? customHours : selectedDuration.hours
    }

    func createBooking(host: User, buyerId: String) async {
        isProcessing = true
        try? await Task.sleep(for: .seconds(1.5))
        let pricing = calculatePrice(for: host)
        let booking = Booking(
            id: UUID().uuidString,
            buyerId: buyerId,
            hostId: host.id,
            hostName: host.name,
            buyerName: "Alex Morgan",
            duration: selectedDuration,
            date: selectedDate,
            totalPrice: pricing.total,
            hostEarnings: pricing.hostEarnings,
            platformFee: pricing.platformFee,
            status: .confirmed,
            city: host.city,
            meetingPlace: nil,
            isReviewedByBuyer: false,
            isReviewedByHost: false,
            createdAt: Date()
        )
        bookings.append(booking)
        isProcessing = false
        showBookingSuccess = true
    }
}
