import SwiftUI

struct DiscoverView: View {
    @Bindable var viewModel: DiscoverViewModel
    let currentUserRole: UserRole
    @State private var selectedSegment: DiscoverSegment = .hosts

    private enum DiscoverSegment: String, CaseIterable {
        case hosts = "Find Hosts"
        case seekers = "Find Seekers"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                segmentPicker

                ScrollView {
                    VStack(spacing: 16) {
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
            .background(Color.black)
            .navigationTitle("Discover")
            .searchable(text: $viewModel.searchText, prompt: "Search hosts, interests...")
            .navigationDestination(for: User.self) { host in
                HostProfileView(host: host)
            }
            .sheet(isPresented: $viewModel.showFilters) {
                FilterSheet(viewModel: viewModel)
            }
            .onAppear {
                selectedSegment = currentUserRole == .host ? .seekers : .hosts
            }
        }
    }

    private var segmentPicker: some View {
        HStack(spacing: 0) {
            ForEach(DiscoverSegment.allCases, id: \.self) { segment in
                Button {
                    withAnimation(.snappy(duration: 0.25)) {
                        selectedSegment = segment
                    }
                } label: {
                    Text(segment.rawValue)
                        .font(.subheadline.bold())
                        .foregroundStyle(selectedSegment == segment ? .white : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            selectedSegment == segment
                            ? Theme.gradientStart.opacity(0.2)
                            : Color.clear
                        )
                        .overlay(alignment: .bottom) {
                            if selectedSegment == segment {
                                Rectangle()
                                    .fill(Theme.gradientStart)
                                    .frame(height: 2)
                            }
                        }
                }
            }
        }
        .background(Theme.surfaceBackground)
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
        LazyVStack(spacing: 12) {
            ForEach(viewModel.filteredHosts, id: \.id) { host in
                NavigationLink(value: host) {
                    HostListCard(host: host)
                }
            }
        }
        .padding(.horizontal, 16)
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.2.slash")
                .font(.system(size: 48))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Theme.gradientStart.opacity(0.6), Theme.gradientEnd.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(spacing: 6) {
                Text("No hosts nearby yet")
                    .font(.title3.bold())
                    .foregroundStyle(.white)

                Text("Try another city or adjust your filters")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Button {
                viewModel.showFilters = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "mappin.circle.fill")
                    Text("Change City")
                }
                .font(.subheadline.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Theme.accent)
                .clipShape(.capsule)
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
                size: 64,
                userId: host.id,
                isVerified: host.isVerified,
                isFeatured: host.isFeatured
            )

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text(host.name)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .lineLimit(1)

                    if host.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption)
                            .foregroundStyle(Theme.verifiedBlue)
                    }
                }

                Text(host.bio)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                HStack(spacing: 12) {
                    HStack(spacing: 3) {
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

                    HStack(spacing: 3) {
                        Image(systemName: "mappin")
                            .font(.caption2)
                        Text(host.city)
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                    if host.hasBackgroundCheck {
                        HStack(spacing: 2) {
                            Image(systemName: "shield.checkmark.fill")
                                .font(.caption2)
                            Text("BG")
                                .font(.caption2.bold())
                        }
                        .foregroundStyle(.green)
                    }
                }
            }

            Spacer(minLength: 0)

            VStack(spacing: 8) {
                Text("$\(Int(host.hourlyRate))")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                Text("/hr")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Text("Book")
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(Theme.accent)
                    .clipShape(.capsule)
            }
        }
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
