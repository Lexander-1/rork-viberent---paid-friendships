import SwiftUI

struct EarningsView: View {
    @State private var showCashOut: Bool = false
    @State private var cashOutSuccess: Bool = false

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
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(.white)

                        Text("You keep 75% of every booking")
                            .font(.caption)
                            .foregroundStyle(Theme.secondaryText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(Theme.cardBackground)
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Theme.border, lineWidth: 1)
                    )

                    VStack(spacing: 8) {
                        Text("Available Balance")
                            .font(.caption)
                            .foregroundStyle(Theme.secondaryText)
                        Text("$\(String(format: "%.2f", totalEarnings))")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(Theme.cardBackground)
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Theme.border, lineWidth: 1)
                    )

                    Button {
                        showCashOut = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "banknote")
                                .font(.body.bold())
                            Text("Cash Out")
                                .font(.body.bold())
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Theme.buttonBackground)
                        .clipShape(.rect(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                        .shadow(color: .white.opacity(0.08), radius: 6, x: 0, y: 0)
                    }

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
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Theme.border, lineWidth: 1)
                            )
                        }
                    }
                }
                .padding(16)
            }
            .background(Theme.background)
            .navigationTitle("Earnings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Color.clear.frame(width: 44, height: 44)
                }
            }
            .alert("Cash Out $\(String(format: "%.2f", totalEarnings))?", isPresented: $showCashOut) {
                Button("Confirm Cash Out") {
                    cashOutSuccess = true
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("$\(String(format: "%.2f", totalEarnings)) will be sent to your linked bank via Stripe. Minimum $10.00.")
            }
            .alert("Payout Initiated!", isPresented: $cashOutSuccess) {
                Button("Done") { }
            } message: {
                Text("$\(String(format: "%.2f", totalEarnings)) is on its way to your bank account. This usually takes 1-3 business days.")
            }
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
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.border, lineWidth: 1)
        )
    }
}
