import SwiftUI

struct EarningsView: View {
    private let samplePayouts: [(String, Double, Date)] = [
        ("Session with Alex M.", 33.75, Date().addingTimeInterval(-86400)),
        ("Session with Jordan L.", 52.50, Date().addingTimeInterval(-86400 * 3)),
        ("Session with Taylor S.", 90.00, Date().addingTimeInterval(-86400 * 5)),
        ("Session with Sam W.", 33.75, Date().addingTimeInterval(-86400 * 8)),
        ("Session with Chris R.", 52.50, Date().addingTimeInterval(-86400 * 12))
    ]

    private var totalEarnings: Double {
        samplePayouts.reduce(0) { $0 + $1.1 }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Text("Total Earned")
                            .font(.subheadline)
                            .foregroundStyle(Theme.secondaryText)

                        Text("$\(String(format: "%.2f", totalEarnings))")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)

                        Text("You keep 75% of every booking")
                            .font(.caption)
                            .foregroundStyle(Theme.secondaryText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(Theme.cardBackground)
                    .clipShape(.rect(cornerRadius: 12))

                    HStack(spacing: 12) {
                        earningsStat(title: "This Week", value: "$86.25")
                        earningsStat(title: "This Month", value: "$262.50")
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Payouts")
                            .font(.headline)
                            .foregroundStyle(.white)

                        ForEach(samplePayouts, id: \.0) { payout in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(payout.0)
                                        .font(.subheadline)
                                        .foregroundStyle(.white)
                                    Text(payout.2, style: .date)
                                        .font(.caption)
                                        .foregroundStyle(Theme.secondaryText)
                                }

                                Spacer()

                                Text("+$\(String(format: "%.2f", payout.1))")
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.green)
                            }
                            .padding(14)
                            .background(Theme.cardBackground)
                            .clipShape(.rect(cornerRadius: 12))
                        }
                    }
                }
                .padding(16)
            }
            .background(Theme.background)
            .navigationTitle("Earnings")
        }
    }

    private func earningsStat(title: String, value: String) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(Theme.secondaryText)
            Text(value)
                .font(.title3.bold())
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 12))
    }
}
