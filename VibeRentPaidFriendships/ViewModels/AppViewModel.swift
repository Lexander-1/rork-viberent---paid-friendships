import SwiftUI

@Observable
@MainActor
class AppViewModel {
    var currentUser: User = User.currentUser
    var isOnboarded: Bool = false
    var hasAgreedToPlatonic: Bool = false
    var isLoggedIn: Bool = false
    var hasSelectedRole: Bool = false
    var selectedTab: Int = 0

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
        } else {
            currentUser.isHost = false
        }
        hasSelectedRole = true
    }

    func logout() {
        currentUser = User.currentUser
        isLoggedIn = false
        isOnboarded = false
        hasAgreedToPlatonic = false
        hasSelectedRole = false
        selectedTab = 0
    }
}
