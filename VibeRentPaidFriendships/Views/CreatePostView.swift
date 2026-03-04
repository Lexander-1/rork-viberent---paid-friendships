import SwiftUI

struct CreatePostView: View {
    @Environment(\.dismiss) private var dismiss
    var feedViewModel: FeedViewModel?
    @State private var caption: String = ""
    @State private var selectedCompanion: String = ""
    @State private var selectedCompanionId: String = ""
    @State private var selectedCity: String = "New York City"
    @State private var isPosting: Bool = false

    private let pastCompanions: [(name: String, id: String)] = [
        ("Sarah Chen", "1"),
        ("Emma Wilson", "5"),
        ("Marcus Johnson", "2")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    captionSection
                    companionSection
                    locationSection
                    photosSection
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
                    postButton
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var captionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("What's the vibe?")
                .font(.subheadline.bold())
                .foregroundStyle(Theme.secondaryText)

            TextField("Share your hang experience...", text: $caption, axis: .vertical)
                .lineLimit(4...8)
                .padding(14)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.border, lineWidth: 1)
                )
        }
    }

    private var companionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tag your companion")
                .font(.subheadline.bold())
                .foregroundStyle(Theme.secondaryText)

            ForEach(pastCompanions, id: \.id) { companion in
                companionRow(companion)
            }
        }
    }

    private func companionRow(_ companion: (name: String, id: String)) -> some View {
        let isSelected = selectedCompanion == companion.name
        return Button {
            selectedCompanion = companion.name
            selectedCompanionId = companion.id
        } label: {
            HStack(spacing: 12) {
                AvatarView(name: companion.name, size: 36, userId: companion.id)
                Text(companion.name)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Theme.accent)
                }
            }
            .padding(12)
            .background(isSelected ? Theme.accent.opacity(0.1) : Theme.cardBackground)
            .clipShape(.rect(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Theme.accent : Theme.border, lineWidth: 1)
            )
        }
    }

    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Location")
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
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.border, lineWidth: 1)
            )
        }
    }

    private var photosSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Photos")
                .font(.subheadline.bold())
                .foregroundStyle(Theme.secondaryText)

            Button { } label: {
                VStack(spacing: 8) {
                    Image(systemName: "camera.fill")
                        .font(.title3)
                        .foregroundStyle(Theme.secondaryText)
                    Text("Add up to 10 photos")
                        .font(.caption)
                        .foregroundStyle(Theme.secondaryText)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
                        .foregroundStyle(Theme.border)
                )
            }
        }
    }

    private var postButton: some View {
        Button {
            createPost()
        } label: {
            if isPosting {
                ProgressView()
                    .tint(Theme.accent)
            } else {
                Text("Post")
                    .fontWeight(.bold)
                    .foregroundStyle(Theme.accent)
            }
        }
        .disabled(caption.isEmpty || selectedCompanion.isEmpty || isPosting)
    }

    private func createPost() {
        isPosting = true
        let newPost = FeedPost(
            id: UUID().uuidString,
            authorId: "current",
            authorName: "Alex Morgan",
            authorPhotoURL: nil,
            authorIsVerified: true,
            taggedUserId: selectedCompanionId,
            taggedUserName: selectedCompanion,
            caption: caption,
            photoURLs: [],
            city: selectedCity,
            locationTag: selectedCity,
            likeCount: 0,
            commentCount: 0,
            isLiked: false,
            isBoosted: false,
            createdAt: Date(),
            comments: []
        )
        feedViewModel?.addPost(newPost)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isPosting = false
            dismiss()
        }
    }
}
