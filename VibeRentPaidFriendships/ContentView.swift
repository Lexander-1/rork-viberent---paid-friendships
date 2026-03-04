import SwiftUI

struct ContentView: View {
    @State private var appViewModel = AppViewModel()
    @State private var feedViewModel = FeedViewModel()
    @State private var discoverViewModel = DiscoverViewModel()
    @State private var chatViewModel = ChatViewModel()

    var body: some View {
        Group {
            if !appViewModel.isOnboarded {
                OnboardingView {
                    appViewModel.completeOnboarding()
                }
            } else if !appViewModel.hasAgreedToPlatonic {
                PlatonicAgreementView {
                    appViewModel.agreeToPlatatonicTerms()
                }
            } else if !appViewModel.isLoggedIn {
                SignUpView {
                    appViewModel.login()
                }
            } else if !appViewModel.hasSelectedRole {
                RoleSelectionView { role in
                    appViewModel.selectRole(role)
                }
            } else {
                if appViewModel.currentUser.role == .customer {
                    customerTabView
                } else {
                    hostTabView
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var customerTabView: some View {
        TabView(selection: $appViewModel.selectedTab) {
            Tab("Feed", systemImage: "house.fill", value: 0) {
                FeedView(viewModel: feedViewModel, users: User.sampleUsers)
            }

            Tab("Discover", systemImage: "magnifyingglass", value: 1) {
                DiscoverView(viewModel: discoverViewModel)
            }

            Tab("Map", systemImage: "map.fill", value: 2) {
                MapTabView(users: User.sampleUsers, selectedCity: feedViewModel.selectedCity)
            }

            Tab("Chat", systemImage: "bubble.left.and.bubble.right.fill", value: 3) {
                ChatListView(viewModel: chatViewModel)
            }

            Tab("Profile", systemImage: "person.fill", value: 4) {
                ProfileView(user: $appViewModel.currentUser, appViewModel: appViewModel, feedViewModel: feedViewModel)
            }
        }
        .tint(Theme.accent)
    }

    private var hostTabView: some View {
        TabView(selection: $appViewModel.selectedTab) {
            Tab("Feed", systemImage: "house.fill", value: 0) {
                FeedView(viewModel: feedViewModel, users: User.sampleUsers)
            }

            Tab("Calendar", systemImage: "calendar", value: 1) {
                MyCalendarView(user: $appViewModel.currentUser)
            }

            Tab("Map", systemImage: "map.fill", value: 2) {
                MapTabView(users: User.sampleUsers, selectedCity: feedViewModel.selectedCity)
            }

            Tab("Earnings", systemImage: "dollarsign.circle.fill", value: 3) {
                EarningsView()
            }

            Tab("Chat", systemImage: "bubble.left.and.bubble.right.fill", value: 4) {
                ChatListView(viewModel: chatViewModel)
            }

            Tab("Profile", systemImage: "person.fill", value: 5) {
                ProfileView(user: $appViewModel.currentUser, appViewModel: appViewModel, feedViewModel: feedViewModel)
            }
        }
        .tint(Theme.accent)
    }
}
