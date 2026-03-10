import SwiftUI

struct ContentView: View {
    @State private var appViewModel = AppViewModel()
    @State private var feedViewModel = FeedViewModel()
    @State private var discoverViewModel = DiscoverViewModel()
    @State private var chatViewModel = ChatViewModel()
    @State private var notificationsViewModel = NotificationsViewModel()
    @State private var crewViewModel = CrewViewModel()
    @State private var selectedPage: AppPage = .feed
    @State private var isDrawerOpen: Bool = false
    @State private var hasLaunched: Bool = false

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
        .opacity(hasLaunched ? 1 : 0)
        .scaleEffect(hasLaunched ? 1.0 : 0.95)
        .preferredColorScheme(appViewModel.themeManager.colorScheme)
        .task {
            await NotificationService.shared.requestPermission()
            withAnimation(.easeOut(duration: 0.5)) {
                hasLaunched = true
            }
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
            FeedView(viewModel: feedViewModel, notificationsViewModel: notificationsViewModel, users: User.sampleUsers, currentUserRole: appViewModel.currentUser.role, isDrawerOpen: $isDrawerOpen, selectedPage: $selectedPage)
        case .discover:
            if appViewModel.currentUser.role == .customer {
                DiscoverView(viewModel: discoverViewModel, isDrawerOpen: $isDrawerOpen)
            } else {
                FeedView(viewModel: feedViewModel, notificationsViewModel: notificationsViewModel, users: User.sampleUsers, currentUserRole: appViewModel.currentUser.role, isDrawerOpen: $isDrawerOpen, selectedPage: $selectedPage)
            }
        case .calendar:
            if appViewModel.currentUser.role == .host {
                MyCalendarView(user: $appViewModel.currentUser, isDrawerOpen: $isDrawerOpen)
            } else {
                FeedView(viewModel: feedViewModel, notificationsViewModel: notificationsViewModel, users: User.sampleUsers, currentUserRole: appViewModel.currentUser.role, isDrawerOpen: $isDrawerOpen, selectedPage: $selectedPage)
            }
        case .crew:
            FindYourCrewView(viewModel: crewViewModel, isDrawerOpen: $isDrawerOpen)
        case .earnings:
            if appViewModel.currentUser.role == .host {
                EarningsView(isDrawerOpen: $isDrawerOpen, user: $appViewModel.currentUser)
            } else {
                FeedView(viewModel: feedViewModel, notificationsViewModel: notificationsViewModel, users: User.sampleUsers, currentUserRole: appViewModel.currentUser.role, isDrawerOpen: $isDrawerOpen, selectedPage: $selectedPage)
            }
        case .chat:
            ChatListView(viewModel: chatViewModel, isDrawerOpen: $isDrawerOpen)
        case .profile:
            ProfileView(user: $appViewModel.currentUser, appViewModel: appViewModel, feedViewModel: feedViewModel, isDrawerOpen: $isDrawerOpen)
        }
    }
}
