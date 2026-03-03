import SwiftUI

struct EditProfileSheet: View {
    @Bindable var viewModel: ProfileViewModel
    @Binding var user: User
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Personal") {
                    TextField("Name", text: $viewModel.editName)
                    TextField("Bio", text: $viewModel.editBio, axis: .vertical)
                        .lineLimit(3...6)
                    Picker("City", selection: $viewModel.editCity) {
                        ForEach(City.allCities, id: \.name) { city in
                            Text(city.name).tag(city.name)
                        }
                    }
                }

                Section("Interests (comma-separated)") {
                    TextField("Coffee, Hiking, Art...", text: $viewModel.editInterests)
                }

                Section("Host Mode") {
                    Toggle("Enable Host Mode", isOn: $viewModel.isHostMode)
                        .tint(Theme.gradientStart)

                    if viewModel.isHostMode {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Hourly Rate: $\(Int(viewModel.editHourlyRate))")
                                .font(.subheadline.bold())
                            Slider(value: $viewModel.editHourlyRate, in: 30...200, step: 5)
                                .tint(Theme.gradientStart)
                            Text("Minimum $30/hr")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.saveChanges(to: &user)
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .foregroundStyle(Theme.gradientStart)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
