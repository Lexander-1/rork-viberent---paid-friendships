import SwiftUI

struct AdminDashboardView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSection: AdminSection = .flagged
    @State private var searchText: String = ""

    private enum AdminSection: String, CaseIterable {
        case flagged = "Flagged"
        case users = "Users"
        case badges = "Badges"
        case stats = "Stats"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Section", selection: $selectedSection) {
                    ForEach(AdminSection.allCases, id: \.self) { section in
                        Text(section.rawValue).tag(section)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.top, 8)

                switch selectedSection {
                case .flagged:
                    flaggedContent
                case .users:
                    usersContent
                case .badges:
                    badgesContent
                case .stats:
                    statsContent
                }
            }
            .background(Theme.background)
            .navigationTitle("Admin Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search users, posts...")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var flaggedContent: some View {
        List {
            Section("Flagged Posts") {
                ForEach(1...3, id: \.self) { i in
                    HStack(spacing: 12) {
                        Image(systemName: "flag.fill")
                            .foregroundStyle(Theme.dangerRed)
                            .frame(width: 28)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Post #\(i) flagged for review")
                                .font(.subheadline.bold())
                                .foregroundStyle(.white)
                            Text("Reported \(i) hour\(i > 1 ? "s" : "") ago")
                                .font(.caption)
                                .foregroundStyle(Theme.secondaryText)
                        }

                        Spacer()

                        HStack(spacing: 8) {
                            Button {
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                            Button {
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Theme.dangerRed)
                            }
                        }
                    }
                    .listRowBackground(Theme.cardBackground)
                }
            }

            Section("Reported Users") {
                ForEach(1...2, id: \.self) { i in
                    HStack(spacing: 12) {
                        AvatarView(name: "User \(i)", size: 36, userId: "reported\(i)")

                        VStack(alignment: .leading, spacing: 4) {
                            Text("User \(i) reported")
                                .font(.subheadline.bold())
                                .foregroundStyle(.white)
                            Text("\(i + 1) reports this week")
                                .font(.caption)
                                .foregroundStyle(Theme.secondaryText)
                        }

                        Spacer()

                        Button("Review") { }
                            .font(.caption.bold())
                            .foregroundStyle(Theme.accent)
                    }
                    .listRowBackground(Theme.cardBackground)
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
    }

    private var usersContent: some View {
        List {
            ForEach(User.sampleUsers.filter { user in
                searchText.isEmpty || user.name.localizedCaseInsensitiveContains(searchText)
            }, id: \.id) { user in
                HStack(spacing: 12) {
                    AvatarView(name: user.name, size: 40, userId: user.id, isVerified: user.isVerified)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.name)
                            .font(.subheadline.bold())
                            .foregroundStyle(.white)
                        Text("\(user.city) \u{2022} \(user.reviewCount) reviews")
                            .font(.caption)
                            .foregroundStyle(Theme.secondaryText)
                    }

                    Spacer()

                    if user.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(Theme.verifiedBlue)
                    }
                }
                .listRowBackground(Theme.cardBackground)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
    }

    private var badgesContent: some View {
        List {
            Section("Pending Verification") {
                ForEach(1...4, id: \.self) { i in
                    HStack(spacing: 12) {
                        AvatarView(name: "Pending \(i)", size: 36, userId: "pending\(i)")

                        VStack(alignment: .leading, spacing: 4) {
                            Text("User \(i) — ID Verification")
                                .font(.subheadline.bold())
                                .foregroundStyle(.white)
                            Text("Submitted \(i) day\(i > 1 ? "s" : "") ago")
                                .font(.caption)
                                .foregroundStyle(Theme.secondaryText)
                        }

                        Spacer()

                        HStack(spacing: 8) {
                            Button {
                            } label: {
                                Text("Approve")
                                    .font(.caption2.bold())
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(.green)
                                    .clipShape(.capsule)
                            }
                            Button {
                            } label: {
                                Text("Deny")
                                    .font(.caption2.bold())
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Theme.dangerRed)
                                    .clipShape(.capsule)
                            }
                        }
                    }
                    .listRowBackground(Theme.cardBackground)
                }
            }

            Section("Background Check Requests") {
                ForEach(1...2, id: \.self) { i in
                    HStack(spacing: 12) {
                        Image(systemName: "shield.checkmark.fill")
                            .foregroundStyle(.green)
                            .frame(width: 28)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("BG Check Request #\(i)")
                                .font(.subheadline.bold())
                                .foregroundStyle(.white)
                            Text("Payment: $9.99 received")
                                .font(.caption)
                                .foregroundStyle(.green)
                        }

                        Spacer()

                        Button("Process") { }
                            .font(.caption.bold())
                            .foregroundStyle(Theme.accent)
                    }
                    .listRowBackground(Theme.cardBackground)
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
    }

    private var statsContent: some View {
        ScrollView {
            VStack(spacing: 16) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    statCard(title: "Total Users", value: "12,847", icon: "person.2.fill", color: Theme.accent)
                    statCard(title: "Active Hosts", value: "3,421", icon: "person.crop.circle.badge.checkmark", color: .green)
                    statCard(title: "Bookings Today", value: "847", icon: "calendar", color: Theme.accent)
                    statCard(title: "Revenue (MTD)", value: "$128.4K", icon: "dollarsign.circle.fill", color: Theme.accent)
                    statCard(title: "Verified Users", value: "9,234", icon: "checkmark.seal.fill", color: Theme.verifiedBlue)
                    statCard(title: "Flagged Posts", value: "23", icon: "flag.fill", color: Theme.dangerRed)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Top Cities")
                        .font(.headline)
                        .foregroundStyle(.white)

                    ForEach(City.allCities.prefix(5)) { city in
                        HStack {
                            Text(city.name)
                                .font(.subheadline)
                                .foregroundStyle(.white)
                            Spacer()
                            Text("\(city.activeUsers) users")
                                .font(.subheadline.bold())
                                .foregroundStyle(Theme.accent)
                        }
                        .padding(12)
                        .background(Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 10))
                    }
                }
            }
            .padding(16)
        }
    }

    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)

            Text(value)
                .font(.title3.bold())
                .foregroundStyle(.white)

            Text(title)
                .font(.caption)
                .foregroundStyle(Theme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 12))
    }
}
