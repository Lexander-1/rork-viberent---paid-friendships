import SwiftUI

struct BookingFlowView: View {
    let host: User
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = BookingViewModel()
    @State private var showPlatonicPopup: Bool = false

    private var pricing: (total: Double, hostEarnings: Double, platformFee: Double) {
        viewModel.calculatePrice(for: host)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    HStack(spacing: 16) {
                        AvatarView(name: host.name, size: 56, userId: host.id, isVerified: host.isVerified)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(host.name)
                                .font(.headline)
                                .foregroundStyle(.white)
                            Text("$\(Int(host.hourlyRate))/hr")
                                .font(.subheadline)
                                .foregroundStyle(Theme.accent)
                        }
                        Spacer()
                    }
                    .padding(16)
                    .background(Theme.cardBackground)
                    .clipShape(.rect(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Duration")
                            .font(.headline)
                            .foregroundStyle(.white)

                        ForEach(Booking.SessionDuration.allCases, id: \.self) { duration in
                            let durationPricing = Booking.calculatePrice(hourlyRate: host.hourlyRate, duration: duration)
                            Button {
                                withAnimation(.snappy) {
                                    viewModel.selectedDuration = duration
                                }
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(duration.label)
                                            .font(.subheadline.bold())
                                            .foregroundStyle(.white)
                                        Text("\(duration.hours) hour\(duration.hours > 1 ? "s" : "")")
                                            .font(.caption)
                                            .foregroundStyle(Theme.secondaryText)
                                    }
                                    Spacer()
                                    Text("$\(Int(durationPricing.total))")
                                        .font(.headline.bold())
                                        .foregroundStyle(viewModel.selectedDuration == duration ? .white : Theme.accent)
                                }
                                .padding(16)
                                .background(viewModel.selectedDuration == duration ? Theme.accent.opacity(0.2) : Theme.cardBackground)
                                .clipShape(.rect(cornerRadius: 12))
                                .overlay {
                                    if viewModel.selectedDuration == duration {
                                        RoundedRectangle(cornerRadius: 12)
                                            .strokeBorder(Theme.accent, lineWidth: 1.5)
                                    }
                                }
                            }
                        }
                    }

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
                        .padding(16)
                        .background(Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 12))
                    }

                    VStack(spacing: 12) {
                        Text("Price Breakdown")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        VStack(spacing: 8) {
                            priceRow("Session (\(viewModel.selectedDuration.label))", value: "$\(Int(pricing.total))")
                            priceRow("Host Earnings (75%)", value: "$\(Int(pricing.hostEarnings))")
                            priceRow("Platform Fee (25%)", value: "$\(Int(pricing.platformFee))")
                            Divider().background(Color.white.opacity(0.1))
                            HStack {
                                Text("Total")
                                    .font(.headline.bold())
                                    .foregroundStyle(.white)
                                Spacer()
                                Text("$\(Int(pricing.total))")
                                    .font(.title3.bold())
                                    .foregroundStyle(Theme.accent)
                            }
                        }
                        .padding(16)
                        .background(Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 12))
                    }

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
