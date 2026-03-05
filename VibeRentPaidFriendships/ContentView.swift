import SwiftUI

struct ContentView: View {
    @State private var appViewModel = AppViewModel()
    @State private var feedViewModel = FeedViewModel()
    @State private var discoverViewModel = DiscoverViewModel()
    @State private var chatViewModel = ChatViewModel()
    @State private var notificationsViewModel = NotificationsViewModel()
    @State private var selectedPage: AppPage = .feed
    @State private var isDrawerOpen: Bool = false

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
                mainAppView
            }
        }
        .preferredColorScheme(appViewModel.themeManager.colorScheme)
        .task {
            await NotificationService.shared.requestPermission()
        }
    }

    private var mainAppView: some View {
        ZStack {
            currentPageView

            SideDrawerView(
                userRole: appViewModel.currentUser.role,
                selectedPage: $selectedPage,
                isOpen: $isDrawerOpen
            )
        }
    }

    @ViewBuilder
    private var currentPageView: some View {
        switch selectedPage {
        case .feed:
            FeedView(viewModel: feedViewModel, notificationsViewModel: notificationsViewModel, users: User.sampleUsers, isDrawerOpen: $isDrawerOpen)
        case .discover:
            DiscoverView(viewModel: discoverViewModel, isDrawerOpen: $isDrawerOpen)
        case .calendar:
            MyCalendarView(user: $appViewModel.currentUser, isDrawerOpen: $isDrawerOpen)
        case .map:
            MapTabView(users: User.sampleUsers, selectedCity: feedViewModel.selectedCity, feedViewModel: feedViewModel, isDrawerOpen: $isDrawerOpen)
        case .earnings:
            EarningsView(isDrawerOpen: $isDrawerOpen, user: $appViewModel.currentUser)
        case .chat:
            ChatListView(viewModel: chatViewModel, isDrawerOpen: $isDrawerOpen)
        case .profile:
            ProfileView(user: $appViewModel.currentUser, appViewModel: appViewModel, feedViewModel: feedViewModel, isDrawerOpen: $isDrawerOpen)
        }
    }
}
