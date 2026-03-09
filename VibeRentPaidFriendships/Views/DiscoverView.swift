import SwiftUI

struct DiscoverView: View {
    @Bindable var viewModel: DiscoverViewModel
    @Binding var isDrawerOpen: Bool
    @State private var selectedUser: User?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 12) {
                        filterBar

                        if viewModel.filteredHosts.isEmpty {
                            emptyState
                        } else {
                            hostList
                        }
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }
            }
            .background(Theme.background)
            .navigationTitle("Discover")
            .toolbar {
                HamburgerButton(isDrawerOpen: $isDrawerOpen)
            }
            .searchable(text: $viewModel.searchText, prompt: "Search hosts, interests...")
            .sheet(isPresented: $viewModel.showFilters) {
                FilterSheet(viewModel: viewModel)
            }
            .sheet(item: $selectedUser) { user in
                NavigationStack {
                    HostProfileView(host: user, viewerRole: .customer, posts: FeedPost.samplePosts.filter { $0.authorId == user.id })
                }
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            }
        }
    }

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(
                    title: viewModel.selectedCity == "All Cities" ? "City" : viewModel.selectedCity,
                    icon: "mappin",
                    isActive: viewModel.selectedCity != "All Cities"
                ) {
                    viewModel.showFilters = true
                }

                ForEach(DiscoverViewModel.SortOption.allCases, id: \.self) { option in
                    FilterChip(
                        title: option.rawValue,
                        icon: nil,
                        isActive: viewModel.sortOption == option
                    ) {
                        viewModel.sortOption = option
                    }
                }

                FilterChip(
                    title: "Verified",
                    icon: "checkmark.seal.fill",
                    isActive: viewModel.verifiedOnly
                ) {
                    viewModel.verifiedOnly.toggle()
                }

                FilterChip(
                    title: "Available Now",
                    icon: "antenna.radiowaves.left.and.right",
                    isActive: viewModel.availableNowOnly
                ) {
                    viewModel.availableNowOnly.toggle()
                }
            }
            .contentMargins(.horizontal, 16)
        }
    }

    private var hostList: some View {
        LazyVStack(spacing: 10) {
            ForEach(viewModel.filteredHosts, id: \.id) { host in
                Button {
                    selectedUser = host
                } label: {
                    HostListCard(host: host)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.2.slash")
                .font(.system(size: 40))
                .foregroundStyle(Theme.secondaryText)

            Text("No hosts nearby yet")
                .font(.title3.bold())
                .foregroundStyle(Theme.primaryText)

            Text("Try another city or adjust your filters")
                .font(.subheadline)
                .foregroundStyle(Theme.secondaryText)

            Button {
                viewModel.showFilters = true
            } label: {
                Text("Change City")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Theme.buttonBackground)
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
                    .shadow(color: .white.opacity(0.08), radius: 6, x: 0, y: 0)
            }
        }
        .padding(.top, 60)
        .padding(.horizontal, 32)
    }
}

struct HostListCard: View {
    let host: User

    var body: some View {
        HStack(spacing: 14) {
            AvatarView(
                name: host.name,
                size: 60,
                userId: host.id,
                isVerified: host.isVerified
            )

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(host.name)
                        .font(.subheadline.bold())
                        .foregroundStyle(Theme.primaryText)
                        .lineLimit(1)

                    if host.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption2)
                            .foregroundStyle(Theme.verifiedBlue)
                    }

                    if host.hostTier != .free {
                        Text(host.hostTier == .elite ? "Elite" : "Pro")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(host.hostTier == .elite ? Theme.gold : Theme.secondaryText)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(host.hostTier == .elite ? Theme.gold.opacity(0.15) : Theme.buttonBackground)
                            .clipShape(.capsule)
                    }
                }

                HStack(spacing: 4) {
                    Text("$\(Int(host.hourlyRate))/hr")
                        .font(.subheadline.bold())
                        .foregroundStyle(Theme.primaryText)
                    Text("+ \(host.hostTier.feeLabel) fee")
                        .font(.caption2)
                        .foregroundStyle(Theme.secondaryText)
                }

                Text(host.bio)
                    .font(.caption)
                    .foregroundStyle(Theme.secondaryText)
                    .lineLimit(2)

                HStack(spacing: 8) {
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundStyle(Theme.secondaryText)
                        Text(String(format: "%.1f", host.rating))
                            .font(.caption2.bold())
                            .foregroundStyle(Theme.primaryText)
                    }

                    HStack(spacing: 3) {
                        Image(systemName: "mappin")
                            .font(.caption2)
                        Text(host.city)
                            .font(.caption2)
                    }
                    .foregroundStyle(Theme.secondaryText)
                    .lineLimit(1)

                    if host.isAvailableNow {
                        HStack(spacing: 3) {
                            Circle()
                                .fill(.green)
                                .frame(width: 6, height: 6)
                            Text("Now")
                                .font(.caption2.bold())
                                .foregroundStyle(.green)
                        }
                    }

                    if host.hasBackgroundCheck {
                        Image(systemName: "shield.checkmark.fill")
                            .font(.caption2)
                            .foregroundStyle(.green)
                    }
                }
            }

            Spacer(minLength: 0)

            Text("Book")
                .font(.caption.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Theme.buttonBackground)
                .clipShape(.rect(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
                .shadow(color: .white.opacity(0.08), radius: 6, x: 0, y: 0)
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(host.hostTier == .elite ? Theme.gold.opacity(0.2) : Theme.border, lineWidth: 1)
        )
    }
}

struct FilterChip: View {
    let title: String
    let icon: String?
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon {
                    Image(systemName: icon)
                        .font(.caption2)
                }
                Text(title)
                    .font(.caption.bold())
            }
            .foregroundStyle(isActive ? Theme.primaryText : Theme.secondaryText)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isActive ? Theme.buttonBackground : Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isActive ? Color.white.opacity(0.12) : Theme.border, lineWidth: 1)
            )
        }
    }
}

struct FilterSheet: View {
    @Bindable var viewModel: DiscoverViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("City") {
                    Picker("City", selection: $viewModel.selectedCity) {
                        Text("All Cities").tag("All Cities")
                        ForEach(City.allCities, id: \.name) { city in
                            Text(city.name).tag(city.name)
                        }
                    }
                }

                Section("Hourly Rate") {
                    VStack(spacing: 8) {
                        HStack {
                            Text("$\(Int(viewModel.minRate))")
                                .font(.subheadline.bold())
                            Spacer()
                            Text("$\(Int(viewModel.maxRate))")
                                .font(.subheadline.bold())
                        }
                        .foregroundStyle(Theme.secondaryText)

                        Slider(value: $viewModel.maxRate, in: 30...200, step: 5)
                            .tint(Theme.secondaryText)
                    }
                }

                Section {
                    Toggle("Verified Only", isOn: $viewModel.verifiedOnly)
                        .tint(Theme.secondaryText)
                    Toggle("Available Now", isOn: $viewModel.availableNowOnly)
                        .tint(.green)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") { dismiss() }
                        .fontWeight(.bold)
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .preferredColorScheme(.dark)
    }
}
