import SwiftUI

@Observable
@MainActor
class AppViewModel {
    var currentUser: User = User.currentUser
    var isOnboarded: Bool = false
    var hasAgreedToPlatonic: Bool = false
    var isLoggedIn: Bool = false
    var hasSelectedRole: Bool = false
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

    func selectRole(_ role: UserRole) {
        currentUser.role = role
        if role == .host {
            currentUser.isHost = true
            if currentUser.hourlyRate < 30 {
                currentUser.hourlyRate = 30
            }
        }
        hasSelectedRole = true
    }

    func switchRole(to role: UserRole) {
        currentUser.role = role
        currentUser.isHost = role == .host
        if role == .host && currentUser.hourlyRate < 30 {
            currentUser.hourlyRate = 30
        }
    }

    func logout() {
        isLoggedIn = false
        isOnboarded = false
        hasAgreedToPlatonic = false
        hasSelectedRole = false
    }
}
