import SwiftUI

@Observable
@MainActor
class NotificationsViewModel {
    var notifications: [AppNotification] = AppNotification.sampleNotifications

    var unreadCount: Int {
        notifications.filter { !$0.isRead }.count
    }

    var hasUnread: Bool {
        unreadCount > 0
    }

    func markAsRead(_ id: String) {
        guard let index = notifications.firstIndex(where: { $0.id == id }) else { return }
        notifications[index].isRead = true
    }

    func markAllAsRead() {
        for i in notifications.indices {
            notifications[i].isRead = true
        }
    }

    func groupedByDate() -> [(String, [AppNotification])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: notifications) { notification -> String in
            if calendar.isDateInToday(notification.createdAt) {
                return "Today"
            } else if calendar.isDateInYesterday(notification.createdAt) {
                return "Yesterday"
            } else {
                return "Earlier"
            }
        }
        let order = ["Today", "Yesterday", "Earlier"]
        return order.compactMap { key in
            guard let items = grouped[key], !items.isEmpty else { return nil }
            return (key, items.sorted { $0.createdAt > $1.createdAt })
        }
    }
}
