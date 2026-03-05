import Foundation
import UserNotifications

@Observable
@MainActor
class NotificationService {
    static let shared = NotificationService()
    var isAuthorized: Bool = false
    private var dailyNotificationCounts: [String: Int] = [:]

    func requestPermission() async {
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            isAuthorized = granted
        } catch {
            isAuthorized = false
        }
    }

    func canSendNotification(for hostId: String, tier: HostSubscriptionTier) -> Bool {
        let count = dailyNotificationCounts[hostId, default: 0]
        return count < tier.maxDailyNotifications
    }

    func sendProximityNotification(hostName: String, hostId: String, distance: String, tier: HostSubscriptionTier) {
        guard canSendNotification(for: hostId, tier: tier) else { return }

        let content = UNMutableNotificationContent()
        content.title = "Host Nearby"
        content.body = "\(hostName) is \(distance) away and available now"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
        dailyNotificationCounts[hostId, default: 0] += 1
    }

    func sendAvailabilityNotification(hostName: String, city: String) {
        let content = UNMutableNotificationContent()
        content.title = "Someone near you is available"
        content.body = "\(hostName) in \(city) is available right now"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func resetDailyCounts() {
        dailyNotificationCounts.removeAll()
    }
}
