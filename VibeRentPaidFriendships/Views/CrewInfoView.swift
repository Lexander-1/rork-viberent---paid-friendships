import SwiftUI

struct CrewInfoView: View {
    let crew: Crew
    @Bindable var viewModel: CrewViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: CrewInfoTab = .media

    nonisolated enum CrewInfoTab: String, CaseIterable, Sendable {
        case media = "Media"
        case voiceNotes = "Voice Notes"
        case files = "Files"

        var icon: String {
            switch self {
            case .media: return "photo.on.rectangle"
            case .voiceNotes: return "waveform"
            case .files: return "doc"
            }
        }
    }

    private var members: [User] {
        User.sampleUsers.filter { crew.memberIds.contains($0.id) }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerSection
                tabSelector
                Divider().background(Theme.border)
                tabContent
            }
            .background(Theme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.body.bold())
                            .foregroundStyle(Theme.primaryText)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Crew Info")
                        .font(.headline)
                        .foregroundStyle(Theme.primaryText)
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Theme.accentRed.opacity(0.5), Theme.buttonBackground],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                Image(systemName: "person.3.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(Theme.primaryText.opacity(0.8))
            }

            VStack(spacing: 4) {
                Text(crew.name)
                    .font(.title3.bold())
                    .foregroundStyle(Theme.primaryText)

                if let tag = crew.interestTag, !tag.isEmpty {
                    Text(tag)
                        .font(.caption.bold())
                        .foregroundStyle(Theme.accentRed)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 3)
                        .background(Theme.accentRed.opacity(0.12))
                        .clipShape(.capsule)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: -8) {
                    ForEach(members, id: \.id) { member in
                        AvatarView(name: member.name, size: 36, userId: member.id, isVerified: member.isVerified)
                            .overlay(
                                Circle().stroke(Theme.background, lineWidth: 2)
                            )
                    }
                }
            }
            .contentMargins(.horizontal, 16)

            Text("\(crew.memberIds.count) members")
                .font(.caption)
                .foregroundStyle(Theme.secondaryText)
        }
        .padding(.vertical, 20)
    }

    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(CrewInfoTab.allCases, id: \.rawValue) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 8) {
                        HStack(spacing: 5) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 12))
                            Text(tab.rawValue)
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundStyle(selectedTab == tab ? Theme.accentRed : Theme.secondaryText)

                        Rectangle()
                            .fill(selectedTab == tab ? Theme.accentRed : Color.clear)
                            .frame(height: 2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .media:
            mediaTab
        case .voiceNotes:
            voiceNotesTab
        case .files:
            filesTab
        }
    }

    private var mediaTab: some View {
        let photos = viewModel.mediaMessages(for: crew)
        return Group {
            if photos.isEmpty {
                emptyTabState(icon: "photo.on.rectangle.angled", text: "No media shared yet")
            } else {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 2),
                        GridItem(.flexible(), spacing: 2),
                        GridItem(.flexible(), spacing: 2)
                    ], spacing: 2) {
                        ForEach(photos, id: \.id) { message in
                            Color(hex: 0x262626)
                                .aspectRatio(1, contentMode: .fit)
                                .overlay {
                                    Image(systemName: "photo.fill")
                                        .font(.title3)
                                        .foregroundStyle(Theme.secondaryText.opacity(0.4))
                                }
                                .clipShape(.rect(cornerRadius: 2))
                        }
                    }
                    .padding(2)
                }
            }
        }
    }

    private var voiceNotesTab: some View {
        let voiceNotes = viewModel.voiceNoteMessages(for: crew)
        return Group {
            if voiceNotes.isEmpty {
                emptyTabState(icon: "waveform", text: "No voice notes shared yet")
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(voiceNotes, id: \.id) { message in
                            HStack(spacing: 12) {
                                Button {} label: {
                                    Image(systemName: "play.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(Theme.accentRed)
                                }

                                VStack(alignment: .leading, spacing: 3) {
                                    Text(message.senderName)
                                        .font(.subheadline.bold())
                                        .foregroundStyle(Theme.primaryText)
                                    HStack(spacing: 6) {
                                        Image(systemName: "waveform")
                                            .font(.caption)
                                            .foregroundStyle(Theme.secondaryText)
                                        Text("\(message.voiceNoteDuration ?? 0)s")
                                            .font(.caption)
                                            .foregroundStyle(Theme.secondaryText)
                                    }
                                }

                                Spacer()

                                Text(message.createdAt, style: .relative)
                                    .font(.system(size: 10))
                                    .foregroundStyle(Theme.secondaryText.opacity(0.6))
                            }
                            .padding(14)
                            .background(Theme.cardBackground)
                            .clipShape(.rect(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Theme.border, lineWidth: 1)
                            )
                        }
                    }
                    .padding(16)
                }
            }
        }
    }

    private var filesTab: some View {
        let files = viewModel.fileMessages(for: crew)
        return Group {
            if files.isEmpty {
                emptyTabState(icon: "doc", text: "No files shared yet")
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(files, id: \.id) { message in
                            HStack(spacing: 12) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Theme.accentRed.opacity(0.12))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "doc.fill")
                                        .font(.title3)
                                        .foregroundStyle(Theme.accentRed)
                                }

                                VStack(alignment: .leading, spacing: 3) {
                                    Text(message.fileName ?? "File")
                                        .font(.subheadline.bold())
                                        .foregroundStyle(Theme.primaryText)
                                        .lineLimit(1)
                                    HStack(spacing: 8) {
                                        Text(message.fileSize ?? "")
                                            .font(.caption)
                                            .foregroundStyle(Theme.secondaryText)
                                        Text("•")
                                            .foregroundStyle(Theme.secondaryText)
                                        Text(message.senderName)
                                            .font(.caption)
                                            .foregroundStyle(Theme.secondaryText)
                                    }
                                }

                                Spacer()

                                Button {} label: {
                                    Image(systemName: "arrow.down.circle")
                                        .font(.title3)
                                        .foregroundStyle(Theme.accentRed)
                                }
                            }
                            .padding(14)
                            .background(Theme.cardBackground)
                            .clipShape(.rect(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Theme.border, lineWidth: 1)
                            )
                        }
                    }
                    .padding(16)
                }
            }
        }
    }

    private func emptyTabState(icon: String, text: String) -> some View {
        VStack(spacing: 14) {
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 36))
                .foregroundStyle(Theme.secondaryText.opacity(0.4))
            Text(text)
                .font(.subheadline)
                .foregroundStyle(Theme.secondaryText)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
