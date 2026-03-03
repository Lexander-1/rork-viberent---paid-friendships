import SwiftUI

struct DiscoverView: View {
    @Bindable var viewModel: DiscoverViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
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

                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.filteredHosts, id: \.id) { host in
                            NavigationLink(value: host) {
                                HostCard(host: host)
                            }
                        }
                    }
                    .padding(.horizontal, 16)

                    if viewModel.filteredHosts.isEmpty {
                        ContentUnavailableView(
                            "No Hosts Found",
                            systemImage: "person.slash",
                            description: Text("Try adjusting your filters")
                        )
                        .padding(.top, 40)
                    }
                }
                .padding(.top, 8)
            }
            .background(Color.black)
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
            .foregroundStyle(isActive ? .white : .secondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isActive ? Theme.gradientStart.opacity(0.3) : Color.white.opacity(0.06))
            .clipShape(.capsule)
            .overlay {
                if isActive {
                    Capsule().strokeBorder(Theme.gradientStart.opacity(0.5), lineWidth: 1)
                }
            }
        }
    }
}

struct HostCard: View {
    let host: User

    var body: some View {
        VStack(spacing: 12) {
            AvatarView(
                name: host.name,
                size: 72,
                userId: host.id,
                isVerified: host.isVerified,
                isFeatured: host.isFeatured
            )

            VStack(spacing: 4) {
                Text(host.name)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .lineLimit(1)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundStyle(.yellow)
                    Text(String(format: "%.1f", host.rating))
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                    Text("(\(host.reviewCount))")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            HStack(spacing: 4) {
                Image(systemName: "mappin")
                    .font(.caption2)
                Text(host.city)
                    .font(.caption2)
                    .lineLimit(1)
            }
            .foregroundStyle(.secondary)

            Text("$\(Int(host.hourlyRate))/hr")
                .font(.headline.bold())
                .foregroundStyle(Theme.gradientStart)

            if host.hasBackgroundCheck {
                HStack(spacing: 4) {
                    Image(systemName: "shield.checkmark.fill")
                        .font(.caption2)
                    Text("BG Check")
                        .font(.caption2.bold())
                }
                .foregroundStyle(.green)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(.rect(cornerRadius: 16))
        .overlay {
            if host.isFeatured {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        LinearGradient(
                            colors: [Theme.goldBorder, Theme.goldBorder.opacity(0.3), Theme.goldBorder],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            }
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
                        .foregroundStyle(.secondary)

                        Slider(value: $viewModel.maxRate, in: 30...200, step: 5)
                            .tint(Theme.gradientStart)
                    }
                }

                Section {
                    Toggle("Verified Only", isOn: $viewModel.verifiedOnly)
                        .tint(Theme.gradientStart)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") { dismiss() }
                        .foregroundStyle(Theme.gradientStart)
                        .fontWeight(.bold)
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .preferredColorScheme(.dark)
    }
}
