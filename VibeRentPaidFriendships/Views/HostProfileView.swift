import SwiftUI

struct HostProfileView: View {
    let host: User
    var viewerRole: UserRole = .customer
    @State private var showBooking: Bool = false
    @State private var showReport: Bool = false
    @State private var showReviews: Bool = false
    @State private var showWriteReview: Bool = false

    private var hostReviews: [Review] {
        Review.sampleReviews.filter { $0.revieweeId == host.id }
    }

    private var hasBookedBefore: Bool {
        Booking.sampleBookings.contains { $0.buyerId == "current" && $0.hostId == host.id && $0.status == .completed }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 14) {
                    AvatarView(name: host.name, size: 90, userId: host.id, isVerified: host.isVerified)

                    VStack(spacing: 6) {
                        HStack(spacing: 6) {
                            Text(host.name)
                                .font(.title2.bold())
                                .foregroundStyle(.white)
                            if host.isVerified {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.subheadline)
                                    .foregroundStyle(Theme.verifiedBlue)
                            }
                        }

                        HStack(spacing: 8) {
                            Text("$\(Int(host.hourlyRate))/hr")
                                .font(.title3.bold())
                                .foregroundStyle(.white)

                            if host.hostTier != .free {
                                Text(host.hostTier.title)
                                    .font(.caption2.bold())
                                    .foregroundStyle(host.hostTier == .elite ? Theme.gold : Theme.secondaryText)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(host.hostTier == .elite ? Theme.gold.opacity(0.15) : Theme.buttonBackground)
                                    .clipShape(.capsule)
                            }
                        }

                        if host.isAvailableNow {
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(.green)
                                    .frame(width: 8, height: 8)
                                Text("Available Now")
                                    .font(.caption.bold())
                                    .foregroundStyle(.green)
                            }
                        }

                        HStack(spacing: 12) {
                            HStack(spacing: 4) {
                                Image(systemName: "mappin")
                                    .font(.caption)
                                Text(host.city)
                            }

                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(Theme.accentRed)
                                Text(String(format: "%.1f", host.rating))
                                    .fontWeight(.bold)
                                Text("(\(host.reviewCount))")
                                    .foregroundStyle(Theme.secondaryText)
                            }
                        }
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                    }

                    HStack(spacing: 12) {
                        if host.isVerified {
                            BadgePill(icon: "checkmark.seal.fill", text: "Verified", color: Theme.verifiedBlue)
                        }
                        if host.hasBackgroundCheck {
                            BadgePill(icon: "shield.checkmark.fill", text: "BG Check", color: .green)
                        }
                        if host.noShowCount == 0 {
                            BadgePill(icon: "hand.thumbsup.fill", text: "Reliable", color: .green)
                        }
                    }

                    Text(host.bio)
                        .font(.body)
                        .foregroundStyle(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)

                    Button {
                        showReviews = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "star.bubble")
                                .font(.subheadline)
                            Text("See Reviews (\(host.reviewCount))")
                                .font(.subheadline.bold())
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Theme.buttonBackground)
                        .clipShape(.rect(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                        .shadow(color: .white.opacity(0.08), radius: 6, x: 0, y: 0)
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.vertical, 24)

                VStack(spacing: 16) {
                    HStack {
                        Text("Interests")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Spacer()
                    }

                    FlowLayout(spacing: 8) {
                        ForEach(host.interests, id: \.self) { interest in
                            Text(interest)
                                .font(.caption.bold())
                                .foregroundStyle(.white.opacity(0.9))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.white.opacity(0.08))
                                .clipShape(.capsule)
                        }
                    }
                }
                .padding(16)

                if viewerRole == .customer {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Pricing")
                            .font(.headline)
                            .foregroundStyle(.white)

                        VStack(spacing: 8) {
                            pricingRow(hours: 1)
                            pricingRow(hours: 2)
                            pricingRow(hours: 4)
                            pricingRow(hours: 8)
                        }
                    }
                    .padding(16)
                }

                Spacer(minLength: 100)
            }
        }
        .background(Theme.background)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("$\(Int(host.hourlyRate))/hr")
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                        if viewerRole == .customer {
                            Text("+ \(host.hostTier.feeLabel) service fee")
                                .font(.caption)
                                .foregroundStyle(Theme.secondaryText)
                        }
                    }

                    Spacer()

                    if viewerRole == .customer {
                        GradientButton("Book Now", icon: "calendar", isFullWidth: false) {
                            showBooking = true
                        }
                    } else {
                        GradientButton("Message", icon: "bubble.left.fill", isFullWidth: false) {
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Report Profile", systemImage: "flag") { showReport = true }
                    Button("Share", systemImage: "square.and.arrow.up") { }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(Theme.secondaryText)
                }
            }
        }
        .sheet(isPresented: $showBooking) {
            BookingFlowView(host: host)
        }
        .fullScreenCover(isPresented: $showReviews) {
            AllReviewsView(host: host, reviews: hostReviews, hasBookedBefore: viewerRole == .customer && hasBookedBefore)
        }
        .alert("Report User", isPresented: $showReport) {
            Button("Report", role: .destructive) { }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This profile will be flagged for review.")
        }
    }

    private func pricingRow(hours: Int) -> some View {
        let pricing = Booking.calculatePrice(hourlyRate: host.hourlyRate, duration: hours == 1 ? .oneHour : hours == 2 ? .twoHours : hours == 4 ? .fourHours : .fullDay, hostTier: host.hostTier)
        let label = hours == 8 ? "Full Day" : "\(hours) Hour\(hours > 1 ? "s" : "")"
        return HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.white)
            Spacer()
            Text("$\(Int(pricing.total))")
                .font(.subheadline.bold())
                .foregroundStyle(.white)
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

struct AllReviewsView: View {
    let host: User
    let reviews: [Review]
    let hasBookedBefore: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var showWriteReview: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(Theme.accentRed)
                            Text(String(format: "%.1f", host.rating))
                                .font(.title.bold())
                                .foregroundStyle(.white)
                        }
                        Text("\(host.reviewCount) reviews")
                            .font(.subheadline)
                            .foregroundStyle(Theme.secondaryText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .background(Theme.cardBackground)
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Theme.border, lineWidth: 1)
                    )

                    if hasBookedBefore {
                        Button {
                            showWriteReview = true
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "pencil.line")
                                Text("Write a Review")
                            }
                            .font(.subheadline.bold())
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Theme.buttonBackground)
                            .clipShape(.rect(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
                            )
                            .shadow(color: .white.opacity(0.08), radius: 6, x: 0, y: 0)
                        }
                    }

                    if reviews.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "text.bubble")
                                .font(.system(size: 32))
                                .foregroundStyle(Theme.secondaryText)
                            Text("No reviews yet")
                                .font(.subheadline)
                                .foregroundStyle(Theme.secondaryText)
                        }
                        .padding(.top, 40)
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(reviews, id: \.id) { review in
                                ReviewCard(review: review)
                            }
                        }
                    }
                }
                .padding(16)
            }
            .background(Theme.background)
            .navigationTitle("Reviews")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showWriteReview) {
                ReviewView(booking: Booking.sampleBookings.first!) { }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct BadgePill: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
            Text(text)
                .font(.caption2.bold())
        }
        .foregroundStyle(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(color.opacity(0.15))
        .clipShape(.capsule)
    }
}

struct ReviewCard: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                AvatarView(name: review.reviewerName, size: 32, userId: review.reviewerId)
                VStack(alignment: .leading, spacing: 1) {
                    Text(review.reviewerName)
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                    Text(review.createdAt, style: .relative)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
                Spacer()
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= review.rating ? "star.fill" : "star")
                            .font(.caption2)
                            .foregroundStyle(star <= review.rating ? Theme.accentRed : Theme.secondaryText)
                    }
                }
            }
            Text(review.text)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.85))
        }
        .padding(12)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.border, lineWidth: 1)
        )
    }
}

nonisolated struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = flowLayout(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = flowLayout(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func flowLayout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
            maxX = max(maxX, x)
        }

        return (CGSize(width: maxX, height: y + rowHeight), positions)
    }
}
