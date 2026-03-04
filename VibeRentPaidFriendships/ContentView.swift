import SwiftUI

struct ContentView: View {
    @State private var appViewModel = AppViewModel()
    @State private var feedViewModel = FeedViewModel()
    @State private var discoverViewModel = DiscoverViewModel()
    @State private var chatViewModel = ChatViewModel()
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
        .preferredColorScheme(.dark)
    }

    private var mainAppView: some View {
        ZStack {
            currentPageView
                .overlay(alignment: .topLeading) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) { isDrawerOpen = true }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                    }
                    .padding(.leading, 8)
                    .padding(.top, 4)
                }

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
            FeedView(viewModel: feedViewModel, users: User.sampleUsers)
        case .discover:
            DiscoverView(viewModel: discoverViewModel)
        case .calendar:
            MyCalendarView(user: $appViewModel.currentUser)
        case .map:
            MapTabView(users: User.sampleUsers, selectedCity: feedViewModel.selectedCity, feedViewModel: feedViewModel)
        case .earnings:
            EarningsView()
        case .chat:
            ChatListView(viewModel: chatViewModel)
        case .profile:
            ProfileView(user: $appViewModel.currentUser, appViewModel: appViewModel, feedViewModel: feedViewModel)
        }
    }
}
