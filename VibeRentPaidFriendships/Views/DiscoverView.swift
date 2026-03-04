import SwiftUI

struct DiscoverView: View {
    @Bindable var viewModel: DiscoverViewModel

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
            .searchable(text: $viewModel.searchText, prompt: "Search hosts, interests...")
            .navigationDestination(for: User.self) { host in
                HostProfileView(host: host)
            }
            .sheet(isPresented: $viewModel.showFilters) {
                FilterSheet(viewModel: viewModel)
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
            }
            .contentMargins(.horizontal, 16)
        }
    }

    private var hostList: some View {
        LazyVStack(spacing: 10) {
            ForEach(viewModel.filteredHosts, id: \.id) { host in
                NavigationLink(value: host) {
                    HostListCard(host: host)
                }
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
                .foregroundStyle(.white)

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
                    .background(Theme.accent)
                    .clipShape(.rect(cornerRadius: 12))
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
                        .foregroundStyle(.white)
                        .lineLimit(1)

                    if host.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption2)
                            .foregroundStyle(Theme.verifiedBlue)
                    }
                }

                Text("$\(Int(host.hourlyRate))/hr")
                    .font(.caption.bold())
                    .foregroundStyle(Theme.accent)

                Text(host.bio)
                    .font(.caption)
                    .foregroundStyle(Theme.secondaryText)
                    .lineLimit(2)

                HStack(spacing: 8) {
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundStyle(Theme.accent)
                        Text(String(format: "%.1f", host.rating))
                            .font(.caption2.bold())
                            .foregroundStyle(.white)
                    }

                    HStack(spacing: 3) {
                        Image(systemName: "mappin")
                            .font(.caption2)
                        Text(host.city)
                            .font(.caption2)
                    }
                    .foregroundStyle(Theme.secondaryText)
                    .lineLimit(1)

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
                .background(Theme.accent)
                .clipShape(.rect(cornerRadius: 12))
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
            .foregroundStyle(isActive ? .white : Theme.secondaryText)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isActive ? Theme.accent : Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isActive ? Theme.accent : Theme.border, lineWidth: 1)
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
                            .tint(Theme.accent)
                    }
                }

                Section {
                    Toggle("Verified Only", isOn: $viewModel.verifiedOnly)
                        .tint(Theme.accent)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") { dismiss() }
                        .foregroundStyle(Theme.accent)
                        .fontWeight(.bold)
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .preferredColorScheme(.dark)
    }
}
