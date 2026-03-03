import SwiftUI

@Observable
@MainActor
class AppViewModel {
    var currentUser: User = User.currentUser
    var isOnboarded: Bool = false
    var hasAgreedToPlatonic: Bool = false
    var isLoggedIn: Bool = false
    var selectedTab: AppTab = .feed

    enum AppTab: Int, CaseIterable {
        case feed = 0
        case discover = 1
        case chat = 2
        case profile = 3
    }

    func completeOnboarding() {
        isOnboarded = true
    }

    func agreeToPlatatonicTerms() {
        hasAgreedToPlatonic = true
    }

    func login() {
        isLoggedIn = true
    }

    func logout() {
        isLoggedIn = false
        isOnboarded = false
        hasAgreedToPlatonic = false
    }
}
