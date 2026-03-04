import SwiftUI

struct MyCalendarView: View {
    @State private var selectedDate: Date = Date()

    private let sampleBookings: [(String, String, Date)] = [
        ("Coffee Chat", "Alex Morgan", Date().addingTimeInterval(86400)),
        ("City Walk", "Jordan Lee", Date().addingTimeInterval(86400 * 2)),
        ("Board Games", "Taylor Swift", Date().addingTimeInterval(86400 * 4))
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .tint(Theme.accent)
                    .padding(16)
                    .background(Theme.cardBackground)
                    .clipShape(.rect(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Upcoming Bookings")
                            .font(.headline)
                            .foregroundStyle(.white)

                        if sampleBookings.isEmpty {
                            Text("No upcoming bookings")
                                .font(.subheadline)
                                .foregroundStyle(Theme.secondaryText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 32)
                        } else {
                            ForEach(sampleBookings, id: \.0) { booking in
                                HStack(spacing: 14) {
                                    Circle()
                                        .fill(Theme.accent)
                                        .frame(width: 8, height: 8)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(booking.0)
                                            .font(.subheadline.bold())
                                            .foregroundStyle(.white)
                                        Text("with \(booking.1)")
                                            .font(.caption)
                                            .foregroundStyle(Theme.secondaryText)
                                    }

                                    Spacer()

                                    Text(booking.2, style: .date)
                                        .font(.caption)
                                        .foregroundStyle(Theme.secondaryText)
                                }
                                .padding(14)
                                .background(Theme.cardBackground)
                                .clipShape(.rect(cornerRadius: 12))
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Availability")
                            .font(.headline)
                            .foregroundStyle(.white)

                        HStack(spacing: 8) {
                            ForEach(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], id: \.self) { day in
                                Text(day)
                                    .font(.caption2.bold())
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(["Mon", "Wed", "Fri", "Sat"].contains(day) ? Theme.accent : Theme.cardBackground)
                                    .clipShape(.rect(cornerRadius: 8))
                            }
                        }

                        Text("Tap days to toggle availability")
                            .font(.caption)
                            .foregroundStyle(Theme.secondaryText)
                    }
                }
                .padding(16)
            }
            .background(Theme.background)
            .navigationTitle("My Calendar")
        }
    }
}
