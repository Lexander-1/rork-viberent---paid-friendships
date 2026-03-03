import SwiftUI

struct HostProfileView: View {
    let host: User
    @State private var showBooking: Bool = false
    @State private var showReport: Bool = false

    private var hostReviews: [Review] {
        Review.sampleReviews.filter { $0.revieweeId == host.id }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    AvatarView(
                        name: host.name,
                        size: 100,
                        userId: host.id,
                        isVerified: host.isVerified,
                        isFeatured: host.isFeatured
                    )

                    VStack(spacing: 6) {
                        HStack(spacing: 8) {
                            Text(host.name)
                                .font(.title2.bold())
                                .foregroundStyle(.white)
                        }

                        HStack(spacing: 12) {
                            HStack(spacing: 4) {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundStyle(Theme.gradientStart)
                                Text(host.city)
                            }

                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(.yellow)
                                Text(String(format: "%.1f", host.rating))
                                    .fontWeight(.bold)
                                Text("(\(host.reviewCount) reviews)")
                                    .foregroundStyle(.secondary)
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
                        if host.isFeatured {
                            BadgePill(icon: "star.fill", text: "Featured", color: Theme.goldBorder)
                        }
                    }

                    Text(host.bio)
                        .font(.body)
                        .foregroundStyle(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
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

                VStack(alignment: .leading, spacing: 16) {
                    Text("Pricing")
                        .font(.headline)
                        .foregroundStyle(.white)

                    VStack(spacing: 8) {
                        ForEach(Booking.SessionDuration.allCases, id: \.self) { duration in
                            let pricing = Booking.calculatePrice(hourlyRate: host.hourlyRate, duration: duration)
                            HStack {
                                Text(duration.label)
                                    .font(.subheadline)
                                    .foregroundStyle(.white)
                                Spacer()
                                Text("$\(Int(pricing.total))")
                                    .font(.subheadline.bold())
                                    .foregroundStyle(Theme.gradientStart)
                            }
                            .padding(12)
                            .background(Color.white.opacity(0.04))
                            .clipShape(.rect(cornerRadius: 10))
                        }
                    }
                }
                .padding(16)

                if !hostReviews.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Reviews")
                            .font(.headline)
                            .foregroundStyle(.white)

                        ForEach(hostReviews, id: \.id) { review in
                            ReviewCard(review: review)
                        }
                    }
                    .padding(16)
                }

                Spacer(minLength: 100)
            }
        }
        .background(Color.black)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("$\(Int(host.hourlyRate))/hr")
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                        Text("75% goes to host")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    GradientButton("Book Now", icon: "calendar", isFullWidth: false) {
                        showBooking = true
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
                        .foregroundStyle(.secondary)
                }
            }
        }
        .sheet(isPresented: $showBooking) {
            BookingFlowView(host: host)
        }
        .alert("Report User", isPresented: $showReport) {
            Button("Report", role: .destructive) { }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This profile will be flagged for review.")
        }
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
                            .foregroundStyle(.yellow)
                    }
                }
            }
            Text(review.text)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.85))
        }
        .padding(12)
        .background(Color.white.opacity(0.04))
        .clipShape(.rect(cornerRadius: 12))
    }
}

struct FlowLayout: Layout {
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
