import SwiftUI
import PhotosUI

struct EditProfileSheet: View {
    @Bindable var viewModel: ProfileViewModel
    @Binding var user: User
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var profileImage: Image?
    @State private var isSaving: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    profilePhotoSection
                    personalInfoSection
                    interestsSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
            .background(Theme.background)
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isSaving = true
                        viewModel.saveChanges(to: &user)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isSaving = false
                            dismiss()
                        }
                    } label: {
                        if isSaving {
                            ProgressView()
                                .tint(Theme.accent)
                        } else {
                            Text("Save")
                                .fontWeight(.bold)
                                .foregroundStyle(Theme.accent)
                        }
                    }
                    .disabled(isSaving)
                }
            }
            .onChange(of: selectedPhoto) { _, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        profileImage = Image(uiImage: uiImage)
                    }
                }
            }
        }
        .presentationDragIndicator(.visible)
        .preferredColorScheme(.dark)
    }

    private var profilePhotoSection: some View {
        VStack(spacing: 12) {
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                ZStack {
                    if let profileImage {
                        profileImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        AvatarView(name: user.name, size: 100, userId: user.id, isVerified: user.isVerified)
                    }

                    Circle()
                        .fill(.black.opacity(0.4))
                        .frame(width: 100, height: 100)

                    Image(systemName: "camera.fill")
                        .font(.title3)
                        .foregroundStyle(.white)
                }
            }

            Text("Tap to change photo")
                .font(.caption)
                .foregroundStyle(Theme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }

    private var personalInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Personal Info")
                .font(.headline)
                .foregroundStyle(.white)

            VStack(spacing: 12) {
                editField("Name", text: $viewModel.editName, icon: "person.fill")
                editField("Bio", text: $viewModel.editBio, icon: "text.quote", isMultiline: true)

                VStack(alignment: .leading, spacing: 8) {
                    Label("City", systemImage: "location.fill")
                        .font(.subheadline.bold())
                        .foregroundStyle(Theme.secondaryText)

                    Picker("City", selection: $viewModel.editCity) {
                        ForEach(City.allCities, id: \.name) { city in
                            Text(city.name).tag(city.name)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
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
    }

    private var interestsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Interests")
                .font(.headline)
                .foregroundStyle(.white)

            editField("Coffee, Hiking, Art...", text: $viewModel.editInterests, icon: "heart.fill")
        }
    }

    private func editField(_ placeholder: String, text: Binding<String>, icon: String, isMultiline: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(placeholder, systemImage: icon)
                .font(.subheadline.bold())
                .foregroundStyle(Theme.secondaryText)

            if isMultiline {
                TextField(placeholder, text: text, axis: .vertical)
                    .lineLimit(3...6)
                    .padding(14)
                    .background(Theme.cardBackground)
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Theme.border, lineWidth: 1)
                    )
            } else {
                TextField(placeholder, text: text)
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
}
