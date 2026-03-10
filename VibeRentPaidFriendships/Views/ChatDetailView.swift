import SwiftUI

struct ChatDetailView: View {
    let conversation: Conversation
    @Bindable var viewModel: ChatViewModel
    @FocusState private var isInputFocused: Bool
    @State private var showCancelAlert: Bool = false
    @State private var showRescheduleSheet: Bool = false
    @State private var bookingActive: Bool = true
    @State private var bookingStatus: String = "Active"
    @State private var showDeletedMessages: Bool = false

    private var messages: [ChatMessage] {
        viewModel.messages[conversation.id] ?? []
    }

    private var otherName: String {
        viewModel.otherParticipantName(in: conversation, currentUserId: "current")
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "shield.checkmark.fill")
                    .font(.caption2)
                    .foregroundStyle(.green)
                Text("This chat is monitored for safety. Platonic interactions only.")
                    .font(.caption2)
                    .foregroundStyle(Theme.secondaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(Color.green.opacity(0.08))

            if bookingActive {
                bookingActionsBar
            }

            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(messages, id: \.id) { message in
                        MessageBubble(message: message, isFromCurrentUser: message.senderId == "current")
                            .contextMenu {
                                Button("Delete Message", systemImage: "trash", role: .destructive) {
                                    viewModel.deleteMessage(message, in: conversation.id)
                                }
                            }
                    }
                }
                .padding(16)
            }
            .defaultScrollAnchor(.bottom)

            Divider().background(Theme.border)

            HStack(spacing: 12) {
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
                    viewModel.sendMessage(in: conversation.id, senderId: "current", senderName: "Alex Morgan")
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
        .navigationTitle(otherName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 14) {
                    Button {
                        showDeletedMessages = true
                    } label: {
                        Image(systemName: "trash")
                            .font(.subheadline)
                            .foregroundStyle(Theme.secondaryText)
                    }

                    Menu {
                        Button("Report Chat", systemImage: "flag") { }
                        Button("Share Location", systemImage: "location") { }
                        Button("Emergency SOS", systemImage: "sos", role: .destructive) { }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundStyle(Theme.secondaryText)
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .alert("Cancel Booking?", isPresented: $showCancelAlert) {
            Button("Request Cancel", role: .destructive) {
                bookingStatus = "Cancel Requested"
            }
            Button("Keep Booking", role: .cancel) { }
        } message: {
            Text("Both parties must confirm cancellation. A refund will be processed via Stripe once both sides agree.")
        }
        .sheet(isPresented: $showRescheduleSheet) {
            ChatRescheduleSheet(otherName: otherName) { newDate in
                bookingStatus = "Reschedule Requested"
            }
        }
        .fullScreenCover(isPresented: $showDeletedMessages) {
            DeletedMessagesView(viewModel: viewModel, conversationId: conversation.id)
        }
    }

    private var bookingActionsBar: some View {
        VStack(spacing: 8) {
            if bookingStatus != "Active" {
                Text(bookingStatus)
                    .font(.caption2.bold())
                    .foregroundStyle(bookingStatus.contains("Cancel") ? Theme.dangerRed : .orange)
            }

            HStack(spacing: 10) {
                Button {
                    showCancelAlert = true
                } label: {
                    Text("Cancel Booking")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Theme.dangerRed)
                        .clipShape(.rect(cornerRadius: 10))
                }

                Button {
                    showRescheduleSheet = true
                } label: {
                    Text("Reschedule")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Theme.buttonBackground)
                        .clipShape(.rect(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Theme.accentRed.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: Theme.buttonGlow, radius: 6, x: 0, y: 0)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Theme.cardBackground)
        }
    }
}

struct DeletedMessagesView: View {
    @Bindable var viewModel: ChatViewModel
    let conversationId: String
    @Environment(\.dismiss) private var dismiss

    private var deletedMessages: [ChatMessage] {
        viewModel.deletedMessages[conversationId] ?? []
    }

    var body: some View {
        NavigationStack {
            Group {
                if deletedMessages.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "trash.slash")
                            .font(.system(size: 40))
                            .foregroundStyle(Theme.secondaryText)
                        Text("No deleted messages")
                            .font(.title3.bold())
                            .foregroundStyle(Theme.primaryText)
                        Text("Messages you delete will appear here for 24 hours before being permanently removed.")
                            .font(.subheadline)
                            .foregroundStyle(Theme.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                } else {
                    List {
                        ForEach(deletedMessages, id: \.id) { message in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(message.senderName)
                                        .font(.caption.bold())
                                        .foregroundStyle(Theme.primaryText)
                                    Spacer()
                                    Text(message.createdAt, style: .relative)
                                        .font(.caption2)
                                        .foregroundStyle(.tertiary)
                                }

                                Text(message.text)
                                    .font(.subheadline)
                                    .foregroundStyle(Theme.secondaryText)

                                HStack {
                                    Text("Auto-deletes in 24h")
                                        .font(.caption2)
                                        .foregroundStyle(Theme.accentRed.opacity(0.7))

                                    Spacer()

                                    Button {
                                        viewModel.recoverMessage(message, in: conversationId)
                                    } label: {
                                        HStack(spacing: 4) {
                                            Image(systemName: "arrow.uturn.backward")
                                                .font(.caption2)
                                            Text("Recover")
                                                .font(.caption.bold())
                                        }
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 12)
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
                            .padding(.vertical, 4)
                            .listRowBackground(Theme.cardBackground)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .background(Theme.background)
            .navigationTitle("Deleted Messages")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct ChatRescheduleSheet: View {
    let otherName: String
    let onReschedule: (Date) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var newDate: Date = Date().addingTimeInterval(86400)

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Reschedule with \(otherName)")
                        .font(.headline)
                        .foregroundStyle(Theme.primaryText)
                    Text("Pick a new date and time. The other party must tap \"Agree to New Time\" for the change to lock in.")
                        .font(.caption)
                        .foregroundStyle(Theme.secondaryText)
                        .multilineTextAlignment(.center)
                }

                DatePicker(
                    "New Date & Time",
                    selection: $newDate,
                    in: Date()...,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.graphical)
                .tint(Theme.accentRed)
                .padding(14)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.border, lineWidth: 1)
                )

                Button {
                    onReschedule(newDate)
                    dismiss()
                } label: {
                    Text("Request Reschedule")
                        .font(.subheadline.bold())
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

                Spacer()
            }
            .padding(16)
            .background(Theme.background)
            .navigationTitle("Reschedule")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    let isFromCurrentUser: Bool

    var body: some View {
        HStack {
            if isFromCurrentUser { Spacer(minLength: 60) }

            VStack(alignment: isFromCurrentUser ? .trailing : .leading, spacing: 4) {
                if !isFromCurrentUser {
                    Text(message.senderName)
                        .font(.caption2.bold())
                        .foregroundStyle(Theme.secondaryText)
                }

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

                Text(message.createdAt, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            if !isFromCurrentUser { Spacer(minLength: 60) }
        }
    }
}
