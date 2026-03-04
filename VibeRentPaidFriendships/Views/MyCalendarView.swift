import SwiftUI

struct MyCalendarView: View {
    @Binding var user: User
    @State private var rateText: String = ""
    @State private var availabilityDate: Date = Date()
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date().addingTimeInterval(3600)
    @State private var availabilitySlots: [AvailabilitySlot] = []
    @State private var rateSaved: Bool = false
    @State private var showCancelAlert: Bool = false
    @State private var showRescheduleSheet: Bool = false
    @State private var selectedBookingIndex: Int?

    @State private var sampleBookings: [BookingEntry] = [
        BookingEntry(id: "be1", seekerName: "Alex Morgan", date: Date().addingTimeInterval(86400), duration: "2 Hours", earnings: 100.00, status: .confirmed),
        BookingEntry(id: "be2", seekerName: "Jordan Lee", date: Date().addingTimeInterval(86400 * 2), duration: "1 Hour", earnings: 45.00, status: .confirmed),
        BookingEntry(id: "be3", seekerName: "Taylor Kim", date: Date().addingTimeInterval(86400 * 4), duration: "4 Hours", earnings: 200.00, status: .confirmed)
    ]

    private var currentRate: Double {
        max(Double(rateText) ?? 30, 30)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    rateSection
                    rateSplitPreview
                    bookingsSection
                    availabilitySection
                }
                .padding(16)
            }
            .background(Theme.background)
            .navigationTitle("My Calendar")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Color.clear.frame(width: 44, height: 44)
                }
            }
        }
        .onAppear {
            rateText = "\(Int(user.hourlyRate))"
        }
        .sheet(isPresented: $showRescheduleSheet) {
            if let index = selectedBookingIndex, index < sampleBookings.count {
                RescheduleSheet(booking: $sampleBookings[index])
            }
        }
    }

    private var rateSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Text("My Current Rate:")
                    .font(.headline)
                    .foregroundStyle(.white)
                Text("$\(Int(user.hourlyRate))/hr")
                    .font(.headline.bold())
                    .foregroundStyle(Theme.accent)
            }

            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    Text("$")
                        .font(.title3.bold())
                        .foregroundStyle(Theme.secondaryText)
                    TextField("30", text: $rateText)
                        .keyboardType(.numberPad)
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                }
                .padding(14)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.border, lineWidth: 1)
                )

                Button {
                    let value = max(Double(rateText) ?? 30, 30)
                    user.hourlyRate = value
                    rateText = "\(Int(value))"
                    rateSaved = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        rateSaved = false
                    }
                } label: {
                    Text(rateSaved ? "Saved!" : "Save Rate")
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(rateSaved ? Color.green : Theme.accent)
                        .clipShape(.rect(cornerRadius: 12))
                }
            }

            Text("Minimum $30/hr")
                .font(.caption)
                .foregroundStyle(Theme.secondaryText)
        }
    }

    private var rateSplitPreview: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Earnings Preview")
                .font(.subheadline.bold())
                .foregroundStyle(Theme.secondaryText)

            let rate = user.hourlyRate
            VStack(spacing: 8) {
                splitRow(hours: 1, rate: rate)
                splitRow(hours: 2, rate: rate)
                splitRow(hours: 4, rate: rate)
                splitRow(hours: 8, rate: rate)
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.border, lineWidth: 1)
        )
    }

    private func splitRow(hours: Int, rate: Double) -> some View {
        let hostEarnings = rate * Double(hours)
        let customerPays = hostEarnings * 1.25
        return HStack {
            Text("\(hours) hr\(hours == 1 ? "" : "s")")
                .font(.subheadline)
                .foregroundStyle(.white)
                .frame(width: 50, alignment: .leading)
            Spacer()
            Text("They pay $\(Int(customerPays))")
                .font(.caption)
                .foregroundStyle(Theme.secondaryText)
            Text("→")
                .font(.caption)
                .foregroundStyle(Theme.secondaryText.opacity(0.5))
            Text("You get $\(Int(hostEarnings))")
                .font(.caption.bold())
                .foregroundStyle(.green)
        }
    }

    private var bookingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Upcoming Bookings")
                .font(.headline)
                .foregroundStyle(.white)

            if sampleBookings.isEmpty {
                Text("No upcoming bookings")
                    .font(.subheadline)
                    .foregroundStyle(Theme.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
            } else {
                ForEach(Array(sampleBookings.enumerated()), id: \.element.id) { index, booking in
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            AvatarView(name: booking.seekerName, size: 40, userId: booking.seekerName)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(booking.seekerName)
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.white)
                                HStack(spacing: 8) {
                                    Text(booking.duration)
                                        .font(.caption)
                                    Text(booking.date, style: .date)
                                        .font(.caption)
                                }
                                .foregroundStyle(Theme.secondaryText)

                                if booking.status == .rescheduleRequested {
                                    Text("Reschedule requested")
                                        .font(.caption2.bold())
                                        .foregroundStyle(.orange)
                                } else if booking.status == .cancelRequested {
                                    Text("Cancel requested")
                                        .font(.caption2.bold())
                                        .foregroundStyle(Theme.dangerRed)
                                }
                            }

                            Spacer()

                            Text("+$\(String(format: "%.2f", booking.earnings))")
                                .font(.subheadline.bold())
                                .foregroundStyle(.green)
                        }

                        if booking.status == .confirmed {
                            HStack(spacing: 10) {
                                Button {
                                    selectedBookingIndex = index
                                    showCancelAlert = true
                                } label: {
                                    Text("Cancel")
                                        .font(.caption.bold())
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(Theme.dangerRed)
                                        .clipShape(.rect(cornerRadius: 12))
                                }

                                Button {
                                    selectedBookingIndex = index
                                    showRescheduleSheet = true
                                } label: {
                                    Text("Reschedule")
                                        .font(.caption.bold())
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(Theme.accent)
                                        .clipShape(.rect(cornerRadius: 12))
                                }
                            }
                        }
                    }
                    .padding(14)
                    .background(Theme.cardBackground)
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Theme.border, lineWidth: 1)
                    )
                }
            }
        }
        .alert("Cancel Booking?", isPresented: $showCancelAlert) {
            Button("Cancel Booking", role: .destructive) {
                if let index = selectedBookingIndex, index < sampleBookings.count {
                    sampleBookings[index].status = .cancelRequested
                }
            }
            Button("Keep Booking", role: .cancel) { }
        } message: {
            Text("The other party must also confirm cancellation. A refund will be processed via Stripe once both sides agree.")
        }
    }

    private var availabilitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Add Availability")
                .font(.headline)
                .foregroundStyle(.white)

            VStack(spacing: 12) {
                DatePicker("Date", selection: $availabilityDate, displayedComponents: .date)
                    .tint(Theme.accent)

                DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                    .tint(Theme.accent)

                DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                    .tint(Theme.accent)
            }
            .padding(14)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.border, lineWidth: 1)
            )

            Button {
                let slot = AvailabilitySlot(
                    date: availabilityDate,
                    startTime: startTime,
                    endTime: endTime
                )
                availabilitySlots.append(slot)
            } label: {
                Text("Add Availability")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Theme.accent)
                    .clipShape(.rect(cornerRadius: 12))
            }

            if !availabilitySlots.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Slots")
                        .font(.subheadline.bold())
                        .foregroundStyle(Theme.secondaryText)

                    ForEach(availabilitySlots, id: \.id) { slot in
                        HStack {
                            Text(slot.date, style: .date)
                                .font(.subheadline)
                                .foregroundStyle(.white)
                            Spacer()
                            Text("\(slot.startTime, style: .time) – \(slot.endTime, style: .time)")
                                .font(.caption)
                                .foregroundStyle(Theme.secondaryText)
                        }
                        .padding(12)
                        .background(Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Theme.border, lineWidth: 1)
                        )
                    }
                }
            }
        }
    }
}

struct RescheduleSheet: View {
    @Binding var booking: BookingEntry
    @Environment(\.dismiss) private var dismiss
    @State private var newDate: Date = Date().addingTimeInterval(86400)

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Reschedule with \(booking.seekerName)")
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text("Pick a new date and time. The other party must agree for the change to lock in.")
                        .font(.caption)
                        .foregroundStyle(Theme.secondaryText)
                        .multilineTextAlignment(.center)
                }

                DatePicker(
                    "New Date & Time",
                    selection: $newDate,
                    in: Date()...,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.graphical)
                .tint(Theme.accent)
                .padding(14)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.border, lineWidth: 1)
                )

                Button {
                    booking.status = .rescheduleRequested
                    booking.date = newDate
                    dismiss()
                } label: {
                    Text("Request Reschedule")
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Theme.accent)
                        .clipShape(.rect(cornerRadius: 12))
                }

                Spacer()
            }
            .padding(16)
            .background(Theme.background)
            .navigationTitle("Reschedule")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .preferredColorScheme(.dark)
    }
}

nonisolated struct AvailabilitySlot: Identifiable, Sendable {
    let id: String = UUID().uuidString
    let date: Date
    let startTime: Date
    let endTime: Date
}

struct BookingEntry: Identifiable, Sendable {
    let id: String
    let seekerName: String
    var date: Date
    let duration: String
    let earnings: Double
    var status: BookingEntryStatus

    nonisolated enum BookingEntryStatus: String, Sendable {
        case confirmed
        case cancelRequested
        case rescheduleRequested
        case cancelled
    }
}
