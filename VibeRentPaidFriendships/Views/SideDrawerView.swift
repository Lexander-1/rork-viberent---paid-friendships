import SwiftUI

struct SideDrawerView: View {
    let userRole: UserRole
    @Binding var selectedPage: AppPage
    @Binding var isOpen: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            Color.black.opacity(isOpen ? 0.5 : 0)
                .ignoresSafeArea()
                .onTapGesture { withAnimation(.easeInOut(duration: 0.25)) { isOpen = false } }
                .allowsHitTesting(isOpen)

            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("VibeRent")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                        .padding(.top, 60)
                        .padding(.bottom, 32)
                        .padding(.horizontal, 24)

                    ForEach(AppPage.pages(for: userRole), id: \.self) { page in
                        Button {
                            selectedPage = page
                            withAnimation(.easeInOut(duration: 0.25)) { isOpen = false }
                        } label: {
                            HStack(spacing: 0) {
                                Text(page.title)
                                    .font(.body)
                                    .fontWeight(selectedPage == page ? .bold : .regular)
                                    .foregroundStyle(selectedPage == page ? .white : Theme.secondaryText)
                                Spacer()
                            }
                            .padding(.vertical, 14)
                            .padding(.horizontal, 24)
                            .background(selectedPage == page ? Theme.accent.opacity(0.12) : .clear)
                        }
                    }

                    Spacer()
                }
                .frame(width: 260)
                .background(Theme.cardBackground)

                Spacer()
            }
            .offset(x: isOpen ? 0 : -260)
        }
        .animation(.easeInOut(duration: 0.25), value: isOpen)
    }
}

enum AppPage: String, Hashable, CaseIterable {
    case feed
    case discover
    case calendar
    case map
    case earnings
    case chat
    case profile

    var title: String {
        switch self {
        case .feed: return "Feed"
        case .discover: return "Discover"
        case .calendar: return "My Calendar"
        case .map: return "Map"
        case .earnings: return "Earnings"
        case .chat: return "Chat"
        case .profile: return "Profile"
        }
    }

    static func pages(for role: UserRole) -> [AppPage] {
        switch role {
        case .customer:
            return [.feed, .discover, .map, .chat, .profile]
        case .host:
            return [.feed, .calendar, .map, .earnings, .chat, .profile]
        }
    }
}
