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
                    safetyShieldOption
                    priceBreakdown
                    dateTimePicker
                    noShowInfo
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
                Text("Your session with \(host.name) is confirmed. Both parties must tap 'Confirm Meet' 3 times (30s apart) before the booking is fully locked.")
            }
            .overlay {
                if viewModel.isProcessing {
                    ZStack {
                        Color.black.opacity(0.6)
                        VStack(spacing: 16) {
                            ProgressView()
                                .controlSize(.large)
                                .tint(.white)
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
                    if host.hostTier != .free {
                        Text(host.hostTier.title)
                            .font(.caption2.bold())
                            .foregroundStyle(host.hostTier == .elite ? Theme.gold : Theme.secondaryText)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(host.hostTier == .elite ? Theme.gold.opacity(0.15) : Theme.buttonBackground)
                            .clipShape(.capsule)
                    }
                }
                Text("$\(Int(host.hourlyRate))/hr")
                    .font(.title3.bold())
                    .foregroundStyle(.white)

                Text("Service fee: \(host.hostTier.feeLabel)")
                    .font(.caption)
                    .foregroundStyle(Theme.secondaryText)
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
                                let p = Booking.calculatePrice(hourlyRate: host.hourlyRate, duration: duration, hostTier: host.hostTier)
                                Text("$\(Int(p.total))")
                                    .font(.caption.bold())
                                    .foregroundStyle(isSelected ? .white.opacity(0.8) : Theme.secondaryText)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(isSelected ? Theme.buttonBackground : Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isSelected ? Color.white.opacity(0.12) : Theme.border, lineWidth: 1)
                        )
                        .shadow(color: isSelected ? .white.opacity(0.08) : .clear, radius: 6, x: 0, y: 0)
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

    private var safetyShieldOption: some View {
        HStack(spacing: 14) {
            Image(systemName: "shield.checkmark.fill")
                .font(.title3)
                .foregroundStyle(viewModel.addSafetyShield ? .green : Theme.secondaryText)

            VStack(alignment: .leading, spacing: 2) {
                Text("Safety Shield — $4.99")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                Text("Extra photo + GPS verification at check-in")
                    .font(.caption)
                    .foregroundStyle(Theme.secondaryText)
            }

            Spacer()

            Toggle("", isOn: $viewModel.addSafetyShield)
                .labelsHidden()
                .tint(.green)
        }
        .padding(14)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(viewModel.addSafetyShield ? Color.green.opacity(0.3) : Theme.border, lineWidth: 1)
        )
    }

    private var priceBreakdown: some View {
        VStack(spacing: 12) {
            Text("Price Breakdown")
                .font(.headline)
                .foregroundStyle(Theme.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 10) {
                let hours = viewModel.effectiveHours

                priceRow("Host rate", value: "$\(Int(host.hourlyRate))/hr × \(hours) hr\(hours == 1 ? "" : "s")")

                priceRow("Service fee (\(host.hostTier.feeLabel))", value: "$\(Int(pricing.platformFee - (viewModel.addSafetyShield ? 4.99 : 0)))")

                if viewModel.addSafetyShield {
                    priceRow("Safety Shield", value: "$4.99")
                }

                Divider().background(Theme.border)

                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("You pay")
                            .font(.subheadline)
                            .foregroundStyle(Theme.secondaryText)
                    }
                    Spacer()
                    Text("$\(Int(pricing.total))")
                        .font(.title2.bold())
                        .foregroundStyle(Theme.primaryText)
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
            .tint(.white)
            .padding(14)
            .background(Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.border, lineWidth: 1)
            )
        }
    }

    private var noShowInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.shield.fill")
                    .foregroundStyle(.orange)
                Text("No-Show Protection")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 6) {
                infoRow("Both tap 'Confirm Meet' 3× (30s apart)")
                infoRow("Both tap 'I'm Here' within 15 min of start")
                infoRow("Host no-show → full refund + 24hr ban")
                infoRow("Customer no-show → Host keeps earnings")
                infoRow("Live check-ins every 30 min during hang")
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

    private func infoRow(_ text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle")
                .font(.caption2)
                .foregroundStyle(.green)
            Text(text)
                .font(.caption)
                .foregroundStyle(Theme.secondaryText)
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
