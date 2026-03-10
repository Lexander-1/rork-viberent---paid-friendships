import SwiftUI

struct FindYourCrewView: View {
    @Bindable var viewModel: CrewViewModel
    @Binding var isDrawerOpen: Bool
    @State private var showCreateCrew: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Button {
                        showCreateCrew = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                            Text("Create Crew")
                                .font(.subheadline.bold())
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Theme.buttonBackground)
                        .clipShape(.rect(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Theme.accentRed.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: Theme.buttonGlow, radius: 6, x: 0, y: 0)
                    }
                    .buttonStyle(ScaleTapStyle())
                    .padding(.horizontal, 16)

                    if viewModel.crews.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(Theme.secondaryText)
                            Text("No crews yet")
                                .font(.title3.bold())
                                .foregroundStyle(Theme.primaryText)
                            Text("Create a crew to start group vibing!")
                                .font(.subheadline)
                                .foregroundStyle(Theme.secondaryText)
                        }
                        .padding(.top, 60)
                    } else {
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.crews, id: \.id) { crew in
                                NavigationLink(value: crew) {
                                    CrewRow(crew: crew)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.top, 12)
            }
            .background(Theme.background)
            .navigationTitle("Your Crews")
            .toolbar {
                HamburgerButton(isDrawerOpen: $isDrawerOpen)
            }
            .navigationDestination(for: Crew.self) { crew in
                CrewChatView(crew: crew, viewModel: viewModel)
            }
            .sheet(isPresented: $showCreateCrew) {
                CreateCrewSheet(viewModel: viewModel)
            }
        }
    }
}

struct CrewRow: View {
    let crew: Crew

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Theme.buttonBackground)
                    .frame(width: 50, height: 50)
                Image(systemName: "person.3.fill")
                    .font(.body)
                    .foregroundStyle(Theme.accentRed)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(crew.name)
                        .font(.subheadline.bold())
                        .foregroundStyle(Theme.primaryText)
                        .lineLimit(1)

                    if let tag = crew.interestTag, !tag.isEmpty {
                        Text(tag)
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(Theme.accentRed)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Theme.accentRed.opacity(0.15))
                            .clipShape(.capsule)
                    }
                }

                Text(crew.lastMessagePreview)
                    .font(.caption)
                    .foregroundStyle(Theme.secondaryText)
                    .lineLimit(1)

                Text("\(crew.memberIds.count) members")
                    .font(.caption2)
                    .foregroundStyle(Theme.secondaryText.opacity(0.7))
            }

            Spacer()

            Text(crew.lastMessageDate, style: .relative)
                .font(.caption2)
                .foregroundStyle(.tertiary)
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

struct CreateCrewSheet: View {
    @Bindable var viewModel: CrewViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var crewName: String = ""
    @State private var interestTag: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Crew Name")
                        .font(.subheadline.bold())
                        .foregroundStyle(Theme.primaryText)

                    TextField("e.g. NYC Coffee Crew", text: $crewName)
                        .padding(14)
                        .background(Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Theme.border, lineWidth: 1)
                        )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Interest Tag (optional)")
                        .font(.subheadline.bold())
                        .foregroundStyle(Theme.primaryText)

                    TextField("e.g. Hiking, Coffee, Gaming", text: $interestTag)
                        .padding(14)
                        .background(Theme.cardBackground)
                        .clipShape(.rect(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Theme.border, lineWidth: 1)
                        )
                }

                GradientButton("Create Crew", icon: "person.3.fill") {
                    viewModel.createCrew(name: crewName, interestTag: interestTag.isEmpty ? nil : interestTag)
                    dismiss()
                }
                .opacity(crewName.isEmpty ? 0.4 : 1)
                .disabled(crewName.isEmpty)

                Spacer()
            }
            .padding(16)
            .background(Theme.background)
            .navigationTitle("New Crew")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

struct CrewChatView: View {
    let crew: Crew
    @Bindable var viewModel: CrewViewModel
    @FocusState private var isInputFocused: Bool
    @State private var showDeleteAlert: Bool = false
    @State private var showMembers: Bool = false
    @State private var showSharePostPicker: Bool = false
    @State private var selectedMemberForBooking: User?

    private var crewData: Crew {
        viewModel.crews.first(where: { $0.id == crew.id }) ?? crew
    }

    private var isCreator: Bool {
        crewData.creatorId == "current"
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(crewData.messages, id: \.id) { message in
                        CrewMessageBubble(
                            message: message,
                            isFromCurrentUser: message.senderId == "current",
                            onReply: { viewModel.replyingTo = message },
                            onTapMember: { name in
                                if let user = User.sampleUsers.first(where: { $0.name == name && $0.id != "current" }) {
                                    selectedMemberForBooking = user
                                }
                            }
                        )
                    }
                }
                .padding(16)
            }
            .defaultScrollAnchor(.bottom)

            if let reply = viewModel.replyingTo {
                HStack(spacing: 8) {
                    Rectangle()
                        .fill(Theme.accentRed)
                        .frame(width: 3)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(reply.senderName)
                            .font(.caption2.bold())
                            .foregroundStyle(Theme.accentRed)
                        Text(reply.text)
                            .font(.caption2)
                            .foregroundStyle(Theme.secondaryText)
                            .lineLimit(1)
                    }
                    Spacer()
                    Button { viewModel.replyingTo = nil } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.body)
                            .foregroundStyle(Theme.secondaryText)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Theme.cardBackground)
            }

            Divider().background(Theme.border)

            HStack(spacing: 10) {
                Button {
                    toggleRecording()
                } label: {
                    Image(systemName: viewModel.isRecording ? "stop.circle.fill" : "mic.fill")
                        .font(.title3)
                        .foregroundStyle(viewModel.isRecording ? Theme.accentRed : Theme.secondaryText)
                }

                TextField("Message...", text: $viewModel.newMessageText, axis: .vertical)
                    .lineLimit(1...4)
                    .focused($isInputFocused)
                    .padding(12)
                    .background(Theme.cardBackground)
                    .clipShape(.capsule)
                    .overlay(
                        Capsule().stroke(Theme.border, lineWidth: 1)
                    )

                Button {
                    viewModel.sendMessage(in: crew.id, senderId: "current", senderName: "Alex Morgan")
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundStyle(viewModel.newMessageText.isEmpty ? Theme.secondaryText : Theme.accentRed)
                }
                .disabled(viewModel.newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial)
        }
        .background(Theme.background)
        .navigationTitle(crewData.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 12) {
                    Button { showMembers = true } label: {
                        Image(systemName: "person.3")
                            .font(.subheadline)
                            .foregroundStyle(Theme.secondaryText)
                    }

                    if isCreator {
                        Button { showDeleteAlert = true } label: {
                            Image(systemName: "trash")
                                .font(.subheadline)
                                .foregroundStyle(Theme.accentRed)
                        }
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .alert("Delete Crew?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteCrew(crew.id)
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This crew will be removed for everyone.")
        }
        .sheet(isPresented: $showMembers) {
            CrewMembersSheet(crew: crewData, onBookMember: { user in
                showMembers = false
                selectedMemberForBooking = user
            })
        }
        .sheet(item: $selectedMemberForBooking) { user in
            NavigationStack {
                HostProfileView(host: user, viewerRole: .customer, posts: [])
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }

    private func toggleRecording() {
        if viewModel.isRecording {
            let duration = min(viewModel.recordingSeconds, 60)
            viewModel.isRecording = false
            viewModel.recordingSeconds = 0
            if duration > 0 {
                viewModel.sendVoiceNote(in: crew.id, senderId: "current", senderName: "Alex Morgan", duration: duration)
            }
        } else {
            viewModel.isRecording = true
            viewModel.recordingSeconds = 0
            startRecordingTimer()
        }
    }

    private func startRecordingTimer() {
        Task {
            while viewModel.isRecording && viewModel.recordingSeconds < 60 {
                try? await Task.sleep(for: .seconds(1))
                if viewModel.isRecording {
                    viewModel.recordingSeconds += 1
                }
            }
            if viewModel.isRecording {
                toggleRecording()
            }
        }
    }
}

struct CrewMessageBubble: View {
    let message: CrewMessage
    let isFromCurrentUser: Bool
    var onReply: () -> Void
    var onTapMember: (String) -> Void

    var body: some View {
        HStack {
            if isFromCurrentUser { Spacer(minLength: 60) }

            VStack(alignment: isFromCurrentUser ? .trailing : .leading, spacing: 4) {
                if !isFromCurrentUser {
                    Button { onTapMember(message.senderName) } label: {
                        Text(message.senderName)
                            .font(.caption2.bold())
                            .foregroundStyle(Theme.accentRed)
                    }
                }

                if let replyText = message.replyToText {
                    HStack(spacing: 6) {
                        Rectangle()
                            .fill(Theme.accentRed.opacity(0.5))
                            .frame(width: 2)
                        Text(replyText)
                            .font(.caption2)
                            .foregroundStyle(Theme.secondaryText)
                            .lineLimit(1)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                }

                Group {
                    switch message.type {
                    case .voiceNote:
                        HStack(spacing: 8) {
                            Image(systemName: "waveform")
                                .font(.subheadline)
                                .foregroundStyle(Theme.accentRed)
                            Text("\(message.voiceNoteDuration ?? 0)s")
                                .font(.caption)
                                .foregroundStyle(Theme.secondaryText)
                            Image(systemName: "play.circle.fill")
                                .font(.title3)
                                .foregroundStyle(Theme.accentRed)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(isFromCurrentUser ? Theme.buttonBackground : Color(hex: 0x333333))
                        .clipShape(.rect(cornerRadius: 18, style: .continuous))

                    case .sharedPost:
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.turn.up.right")
                                    .font(.caption2)
                                Text("Shared from Feed")
                                    .font(.caption2.bold())
                            }
                            .foregroundStyle(Theme.accentRed)

                            if let caption = message.sharedPostCaption {
                                Text(caption)
                                    .font(.caption)
                                    .foregroundStyle(Theme.primaryText)
                                    .lineLimit(3)
                            }
                            if let author = message.sharedPostAuthor {
                                Text("— \(author)")
                                    .font(.caption2)
                                    .foregroundStyle(Theme.secondaryText)
                            }
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(isFromCurrentUser ? Theme.buttonBackground : Color(hex: 0x333333))
                        .clipShape(.rect(cornerRadius: 18, style: .continuous))

                    case .bookingAlert:
                        HStack(spacing: 8) {
                            Image(systemName: "calendar.badge.checkmark")
                                .font(.subheadline)
                                .foregroundStyle(.green)
                            Text(message.bookingInfo ?? message.text)
                                .font(.caption.bold())
                                .foregroundStyle(Theme.primaryText)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.green.opacity(0.1))
                        .clipShape(.rect(cornerRadius: 18, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(Color.green.opacity(0.3), lineWidth: 0.5)
                        )

                    case .text:
                        Text(message.text)
                            .font(.subheadline)
                            .foregroundStyle(Theme.primaryText)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(isFromCurrentUser ? Theme.buttonBackground : Color(hex: 0x333333))
                            .clipShape(.rect(cornerRadius: 18, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(isFromCurrentUser ? Theme.accentRed.opacity(0.2) : Theme.border, lineWidth: 0.5)
                            )
                    }
                }
                .contextMenu {
                    Button("Reply", systemImage: "arrowshape.turn.up.left") { onReply() }
                }

                Text(message.createdAt, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            if !isFromCurrentUser { Spacer(minLength: 60) }
        }
    }
}

struct CrewMembersSheet: View {
    let crew: Crew
    var onBookMember: (User) -> Void
    @Environment(\.dismiss) private var dismiss

    private var members: [User] {
        User.sampleUsers.filter { crew.memberIds.contains($0.id) }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(members, id: \.id) { member in
                    HStack(spacing: 12) {
                        AvatarView(name: member.name, size: 40, userId: member.id, isVerified: member.isVerified)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(member.name)
                                .font(.subheadline.bold())
                                .foregroundStyle(Theme.primaryText)
                            if member.isHost {
                                Text("$\(Int(member.hourlyRate))/hr")
                                    .font(.caption)
                                    .foregroundStyle(Theme.secondaryText)
                            }
                        }

                        Spacer()

                        if member.id != "current" && member.isHost {
                            Button {
                                onBookMember(member)
                            } label: {
                                Text("Book")
                                    .font(.caption.bold())
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 6)
                                    .background(Theme.buttonBackground)
                                    .clipShape(.rect(cornerRadius: 8))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Theme.accentRed.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .listRowBackground(Theme.cardBackground)
                }
            }
            .listStyle(.plain)
            .background(Theme.background)
            .scrollContentBackground(.hidden)
            .navigationTitle("Members")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
