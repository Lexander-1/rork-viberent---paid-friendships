import SwiftUI

struct NotificationsView: View {
    @Bindable var viewModel: NotificationsViewModel
    var onNavigate: ((AppNotification) -> Void)?
    @Environment(\.dismiss) private var dismiss
    @State var themeManager: ThemeManager = ThemeManager.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    if viewModel.notifications.isEmpty {
                        ContentUnavailableView(
                            "No Notifications",
                            systemImage: "bell.slash",
                            description: Text("You're all caught up!")
                        )
                        .padding(.top, 60)
                    } else {
                        ForEach(viewModel.groupedByDate(), id: \.0) { section, items in
                            sectionHeader(section)

                            ForEach(items, id: \.id) { notification in
                                Button {
                                    viewModel.markAsRead(notification.id)
                                    dismiss()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        onNavigate?(notification)
                                    }
                                } label: {
                                    NotificationRow(notification: notification, themeManager: themeManager)
                                }

                                Divider()
                                    .background(themeManager.border)
                            }
                        }
                    }
                }
            }
            .background(themeManager.background)
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.body)
                            .foregroundStyle(themeManager.secondaryText)
                    }
                }

                if viewModel.hasUnread {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            viewModel.markAllAsRead()
                        } label: {
                            Text("Read All")
                                .font(.subheadline)
                                .foregroundStyle(themeManager.secondaryText)
                        }
                    }
                }
            }
        }
        .preferredColorScheme(themeManager.colorScheme)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.subheadline.bold())
            .foregroundStyle(themeManager.secondaryText)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 8)
    }
}

struct NotificationRow: View {
    let notification: AppNotification
    let themeManager: ThemeManager

    private var iconColor: Color {
        switch notification.type {
        case .like: return Theme.accentRed
        case .reply, .mention: return Theme.accentRed
        case .bookingConfirmed: return Color(hex: 0x4CAF50)
        case .bookingCancelled: return Theme.accentRed
        case .bookingUpdate, .bookingReschedule: return Color(hex: 0xFFA726)
        case .newFollower: return Theme.verifiedBadge
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                AvatarView(name: notification.fromUserName, size: 44, userId: notification.fromUserId, isVerified: notification.fromUserIsVerified)

                Image(systemName: notification.type.icon)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 20, height: 20)
                    .background(iconColor)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(themeManager.background, lineWidth: 2))
                    .offset(x: 4, y: 4)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(notification.fromUserName)
                    .font(.subheadline.bold())
                    .foregroundStyle(themeManager.primaryText)
                +
                Text(" \(notification.message)")
                    .font(.subheadline)
                    .foregroundStyle(themeManager.secondaryText)

                Text(notification.createdAt, style: .relative)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            if !notification.isRead {
                Circle()
                    .fill(Theme.accentRed)
                    .frame(width: 8, height: 8)
                    .padding(.top, 6)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(notification.isRead ? Color.clear : themeManager.cardBackground.opacity(0.5))
    }
}
