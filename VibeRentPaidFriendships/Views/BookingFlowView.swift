import SwiftUI

struct BookingFlowView: View {
    let host: User
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = BookingViewModel()
    @State private var showPlatonicPopup: Bool = false
    @State private var customHoursText: String = "3"

    private var pricing: (total: Double, hostEarnings: Double, platformFee: Double) {
        viewModel.calculatePrice(for: host)
    }

    private let presetDurations: [Booking.SessionDuration] = [.oneHour, .twoHours, .fourHours, .fullDay, .custom]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    hostHeader
                    durationPicker
                    priceBreakdown
                    dateTimePicker
                    Spacer(minLength: 80)
                }
                .padding(16)
            }
            .background(Theme.background)
            .navigationTitle("Book \(host.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 0) {
                    Divider()
                    GradientButton("Confirm Booking — $\(Int(pricing.total))", icon: "creditcard.fill") {
                        showPlatonicPopup = true
                    }
                    .padding(16)
                    .background(.ultraThinMaterial)
                }
            }
            .alert("Platonic Only Reminder", isPresented: $showPlatonicPopup) {
                Button("I Agree — Book Now") {
                    Task {
                        await viewModel.createBooking(host: host, buyerId: "current")
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This booking is for platonic companionship only. Any inappropriate behavior will result in immediate account termination.")
            }
            .alert("Booking Confirmed!", isPresented: $viewModel.showBookingSuccess) {
                Button("Done") { dismiss() }
            } message: {
                Text("Your session with \(host.name) is confirmed. A chat has been opened so you can coordinate details.")
            }
            .overlay {
                if viewModel.isProcessing {
                    ZStack {
                        Color.black.opacity(0.6)
                        VStack(spacing: 16) {
                            ProgressView()
                                .controlSize(.large)
                                .tint(Theme.accent)
                            Text("Processing...")
                                .font(.subheadline)
                                .foregroundStyle(Theme.secondaryText)
                        }
                    }
                    .ignoresSafeArea()
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var hostHeader: some View {
        HStack(spacing: 14) {
            AvatarView(name: host.name, size: 56, userId: host.id, isVerified: host.isVerified)
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(host.name)
                        .font(.headline)
                        .foregroundStyle(.white)
                    if host.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption)
                            .foregroundStyle(Theme.verifiedBlue)
                    }
                }
                Text("$\(Int(host.hourlyRate))/hr")
                    .font(.title3.bold())
                    .foregroundStyle(Theme.accent)
            }
            Spacer()
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.border, lineWidth: 1)
        )
    }

    private var durationPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose Duration")
                .font(.headline)
                .foregroundStyle(.white)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(presetDurations, id: \.self) { duration in
                    Button {
                        viewModel.selectedDuration = duration
                        if duration == .custom {
                            viewModel.customHours = Int(customHoursText) ?? 3
                        }
                    } label: {
                        let isSelected = viewModel.selectedDuration == duration
                        VStack(spacing: 4) {
                            Text(duration.label)
                                .font(.subheadline.bold())
                                .foregroundStyle(.white)
                            if duration != .custom {
                                let p = Booking.calculatePrice(hourlyRate: host.hourlyRate, duration: duration)
                                Text("$\(Int(p.total))")
                                    .font(.caption.bold())
                                    .foregroundStyle(isSelected ? .white.opacity(0.8) : Theme.secondaryText)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(isSelected ? Theme.accent.opacity(0.25) : Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isSelected ? Theme.accent : Theme.border, lineWidth: 1)
                        )
                    }
                }
            }

            if viewModel.selectedDuration == .custom {
                HStack(spacing: 12) {
                    Text("Hours:")
                        .font(.subheadline)
                        .foregroundStyle(Theme.secondaryText)
                    TextField("3", text: $customHoursText)
                        .keyboardType(.numberPad)
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                        .frame(width: 60)
                        .padding(10)
                        .background(Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Theme.border, lineWidth: 1)
                        )
                        .onChange(of: customHoursText) { _, newValue in
                            let val = max(Int(newValue) ?? 1, 1)
                            viewModel.customHours = val
                        }
                }
                .padding(.top, 4)
            }
        }
    }

    private var priceBreakdown: some View {
        VStack(spacing: 12) {
            Text("Price Breakdown")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 10) {
                let hours = viewModel.effectiveHours

                priceRow("Host rate", value: "$\(Int(host.hourlyRate))/hr × \(hours) hr\(hours == 1 ? "" : "s")")

                Divider().background(Theme.border)

                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("You pay")
                            .font(.subheadline)
                            .foregroundStyle(Theme.secondaryText)
                        Text("(includes 25% service fee)")
                            .font(.caption2)
                            .foregroundStyle(Theme.secondaryText.opacity(0.7))
                    }
                    Spacer()
                    Text("$\(Int(pricing.total))")
                        .font(.title2.bold())
                        .foregroundStyle(Theme.accent)
                }

                HStack {
                    Text("Host receives")
                        .font(.subheadline)
                        .foregroundStyle(Theme.secondaryText)
                    Spacer()
                    Text("$\(Int(pricing.hostEarnings))")
                        .font(.headline.bold())
                        .foregroundStyle(.green)
                }

                HStack {
                    Text("Platform fee (25%)")
                        .font(.caption)
                        .foregroundStyle(Theme.secondaryText.opacity(0.7))
                    Spacer()
                    Text("$\(Int(pricing.platformFee))")
                        .font(.caption.bold())
                        .foregroundStyle(Theme.secondaryText.opacity(0.7))
                }
            }
            .padding(16)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.border, lineWidth: 1)
            )
        }
    }

    private var dateTimePicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Date & Time")
                .font(.headline)
                .foregroundStyle(.white)

            DatePicker(
                "Select Date",
                selection: $viewModel.selectedDate,
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
        }
    }

    private func priceRow(_ title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(Theme.secondaryText)
            Spacer()
            Text(value)
                .font(.subheadline.bold())
                .foregroundStyle(.white)
        }
    }
}
