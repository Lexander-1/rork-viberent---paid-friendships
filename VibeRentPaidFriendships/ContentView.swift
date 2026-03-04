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
                    withAnimation(.snappy) { appViewModel.completeOnboarding() }
                }
            } else if !appViewModel.hasAgreedToPlatonic {
                PlatonicAgreementView {
                    withAnimation(.snappy) { appViewModel.agreeToPlatatonicTerms() }
                }
            } else if !appViewModel.isLoggedIn {
                SignUpView {
                    withAnimation(.snappy) { appViewModel.login() }
                }
            } else if !appViewModel.hasSelectedRole {
                RoleSelectionView { role in
                    withAnimation(.snappy) { appViewModel.selectRole(role) }
                }
            } else {
                mainTabView
            }
        }
        .preferredColorScheme(.dark)
    }

    private var mainTabView: some View {
        TabView(selection: $appViewModel.selectedTab) {
            Tab("Feed", systemImage: "house.fill", value: .feed) {
                FeedView(viewModel: feedViewModel, users: User.sampleUsers)
            }

            Tab("Discover", systemImage: "sparkle.magnifyingglass", value: .discover) {
                DiscoverView(viewModel: discoverViewModel, currentUserRole: appViewModel.currentUser.role)
            }

            Tab("Chat", systemImage: "bubble.left.and.bubble.right.fill", value: .chat) {
                ChatListView(viewModel: chatViewModel)
            }

            Tab("Profile", systemImage: "person.fill", value: .profile) {
                ProfileView(user: $appViewModel.currentUser, appViewModel: appViewModel)
            }
        }
        .tint(Theme.gradientStart)
    }
}
