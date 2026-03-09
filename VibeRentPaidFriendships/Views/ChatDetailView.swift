import SwiftUI

struct ChatDetailView: View {
    let conversation: Conversation
    @Bindable var viewModel: ChatViewModel
    @FocusState private var isInputFocused: Bool
    @State private var showCancelAlert: Bool = false
    @State private var showRescheduleSheet: Bool = false
    @State private var bookingActive: Bool = true
    @State private var bookingStatus: String = "Active"

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
                        .foregroundStyle(viewModel.newMessageText.isEmpty ? Theme.secondaryText : .white)
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
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                        .shadow(color: .white.opacity(0.08), radius: 6, x: 0, y: 0)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Theme.cardBackground)
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
                .tint(.white)
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
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                        .shadow(color: .white.opacity(0.08), radius: 6, x: 0, y: 0)
                }

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
        .preferredColorScheme(.dark)
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
                    .background(isFromCurrentUser ? Theme.buttonBackground : Color.white.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 18, style: .continuous))

                Text(message.createdAt, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            if !isFromCurrentUser { Spacer(minLength: 60) }
        }
    }
}
