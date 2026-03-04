import SwiftUI

struct CreatePostView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var caption: String = ""
    @State private var selectedCompanion: String = ""
    @State private var selectedCity: String = "New York City"

    private let pastCompanions = ["Sarah Chen", "Emma Wilson", "Marcus Johnson"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("What's the vibe?", systemImage: "text.quote")
                            .font(.subheadline.bold())
                            .foregroundStyle(Theme.secondaryText)

                        TextField("Share your hang experience...", text: $caption, axis: .vertical)
                            .lineLimit(4...8)
                            .padding(16)
                            .background(Theme.cardBackground)
                            .clipShape(.rect(cornerRadius: 12))
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Label("Tag your companion", systemImage: "person.fill")
                            .font(.subheadline.bold())
                            .foregroundStyle(Theme.secondaryText)

                        ForEach(pastCompanions, id: \.self) { name in
                            Button {
                                selectedCompanion = name
                            } label: {
                                HStack {
                                    AvatarView(name: name, size: 36, userId: name)
                                    Text(name)
                                        .font(.subheadline)
                                        .foregroundStyle(.white)
                                    Spacer()
                                    if selectedCompanion == name {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(Theme.accent)
                                    }
                                }
                                .padding(12)
                                .background(selectedCompanion == name ? Theme.accent.opacity(0.1) : Theme.cardBackground)
                                .clipShape(.rect(cornerRadius: 12))
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Label("Location", systemImage: "mappin")
                            .font(.subheadline.bold())
                            .foregroundStyle(Theme.secondaryText)

                        Picker("City", selection: $selectedCity) {
                            ForEach(City.allCities, id: \.name) { city in
                                Text(city.name).tag(city.name)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.white)
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 12))
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Label("Photos", systemImage: "photo.on.rectangle")
                            .font(.subheadline.bold())
                            .foregroundStyle(Theme.secondaryText)

                        Button {
                        } label: {
                            VStack(spacing: 12) {
                                Image(systemName: "camera.fill")
                                    .font(.title2)
                                    .foregroundStyle(Theme.secondaryText)
                                Text("Add up to 10 photos")
                                    .font(.subheadline)
                                    .foregroundStyle(Theme.secondaryText)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 120)
                            .background(Theme.cardBackground)
                            .clipShape(.rect(cornerRadius: 12))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [8]))
                                    .foregroundStyle(Theme.secondaryText.opacity(0.3))
                            }
                        }
                    }
                }
                .padding(16)
            }
            .background(Theme.background)
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") { dismiss() }
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.accent)
                        .disabled(caption.isEmpty || selectedCompanion.isEmpty)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
