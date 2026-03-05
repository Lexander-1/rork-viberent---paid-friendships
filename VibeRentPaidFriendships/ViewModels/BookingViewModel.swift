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
    var addSafetyShield: Bool = false

    func calculatePrice(for host: User) -> (total: Double, hostEarnings: Double, platformFee: Double) {
        var result = Booking.calculatePrice(hourlyRate: host.hourlyRate, duration: selectedDuration, customHours: customHours, hostTier: host.hostTier)
        if addSafetyShield {
            result = (total: result.total + 4.99, hostEarnings: result.hostEarnings, platformFee: result.platformFee + 4.99)
        }
        return result
    }

    var effectiveHours: Int {
        selectedDuration == .custom ? customHours : selectedDuration.hours
    }

    func confirmMeetTap(bookingId: String, isHost: Bool) {
        guard let index = bookings.firstIndex(where: { $0.id == bookingId }) else { return }

        if isHost {
            let lastTap = bookings[index].lastHostConfirmTap
            if let lastTap, Date().timeIntervalSince(lastTap) < 30 {
                return
            }
            bookings[index].hostConfirmMeetTaps += 1
            bookings[index].lastHostConfirmTap = Date()
        } else {
            let lastTap = bookings[index].lastBuyerConfirmTap
            if let lastTap, Date().timeIntervalSince(lastTap) < 30 {
                return
            }
            bookings[index].buyerConfirmMeetTaps += 1
            bookings[index].lastBuyerConfirmTap = Date()
        }

        if bookings[index].hostConfirmMeetTaps >= 3 && bookings[index].buyerConfirmMeetTaps >= 3 {
            bookings[index].status = .confirmed
        }
    }

    func confirmHere(bookingId: String, isHost: Bool) {
        guard let index = bookings.firstIndex(where: { $0.id == bookingId }) else { return }

        if isHost {
            bookings[index].hostConfirmedHere = true
        } else {
            bookings[index].buyerConfirmedHere = true
        }

        if bookings[index].hostConfirmedHere && bookings[index].buyerConfirmedHere {
            bookings[index].status = .inProgress
        }
    }

    func liveCheckIn(bookingId: String) {
        guard let index = bookings.firstIndex(where: { $0.id == bookingId }) else { return }
        bookings[index].liveCheckInCount += 1
        bookings[index].lastCheckIn = Date()
    }

    func handleNoShow(bookingId: String, isHostNoShow: Bool) {
        guard let index = bookings.firstIndex(where: { $0.id == bookingId }) else { return }
        bookings[index].status = .noShow
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
            status: .awaitingConfirmMeet,
            city: host.city,
            meetingPlace: nil,
            isReviewedByBuyer: false,
            isReviewedByHost: false,
            createdAt: Date(),
            hostTier: host.hostTier,
            confirmMeetCount: 0,
            hostConfirmedHere: false,
            buyerConfirmedHere: false,
            lastCheckIn: nil,
            hasSafetyShield: addSafetyShield,
            hostConfirmMeetTaps: 0,
            buyerConfirmMeetTaps: 0,
            lastHostConfirmTap: nil,
            lastBuyerConfirmTap: nil,
            liveCheckInCount: 0
        )
        bookings.append(booking)
        isProcessing = false
        showBookingSuccess = true
    }
}
