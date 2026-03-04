import SwiftUI

struct CitySelectorView: View {
    @Environment(\.dismiss) private var dismiss
    let selectedCity: String
    let onSelect: (String) -> Void
    @State private var searchText: String = ""

    private var filteredCities: [City] {
        let sorted = City.allCities.sorted { $0.activeUsers > $1.activeUsers }
        if searchText.isEmpty { return sorted }
        return sorted.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        onSelect("All Cities")
                    } label: {
                        HStack {
                            Image(systemName: "globe")
                                .font(.title3)
                                .foregroundStyle(Theme.accent)
                                .frame(width: 32)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("All Cities")
                                    .font(.body.bold())
                                    .foregroundStyle(.white)
                                Text("Show posts from everywhere")
                                    .font(.caption)
                                    .foregroundStyle(Theme.secondaryText)
                            }

                            Spacer()

                            if selectedCity == "All Cities" {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(Theme.accent)
                            }
                        }
                    }
                }

                Section("Available Cities") {
                    ForEach(filteredCities) { city in
                        Button {
                            onSelect(city.name)
                        } label: {
                            HStack {
                                Image(systemName: city.id == "virtual" ? "video.fill" : "mappin.circle.fill")
                                    .font(.title3)
                                    .foregroundStyle(Theme.accent)
                                    .frame(width: 32)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(city.name)
                                        .font(.body)
                                        .foregroundStyle(.white)
                                    Text("\(city.activeUsers) active users")
                                        .font(.caption)
                                        .foregroundStyle(Theme.secondaryText)
                                }

                                Spacer()

                                if selectedCity == city.name {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Theme.accent)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .searchable(text: $searchText, prompt: "Search cities")
            .navigationTitle("Select City")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Theme.accent)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
