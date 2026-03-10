import SwiftUI

struct SideDrawerView: View {
    let userRole: UserRole
    @Binding var selectedPage: AppPage
    @Binding var isOpen: Bool
    @State var themeManager: ThemeManager = ThemeManager.shared

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
                        .foregroundStyle(Theme.primaryText)
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
                                    .foregroundStyle(selectedPage == page ? Theme.primaryText : Theme.secondaryText)
                                Spacer()
                            }
                            .padding(.vertical, 14)
                            .padding(.horizontal, 24)
                            .background(selectedPage == page ? Theme.buttonBackground.opacity(0.6) : .clear)
                        }
                    }

                    Spacer()

                    HStack {
                        Spacer()
                        Button {
                            withAnimation(.spring(duration: 0.3)) {
                                if themeManager.currentTheme == .light {
                                    themeManager.currentTheme = .dark
                                } else {
                                    themeManager.currentTheme = .light
                                }
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Theme.buttonBackground)
                                    .frame(width: 48, height: 48)
                                    .overlay(
                                        Circle()
                                            .stroke(Theme.accentRed.opacity(0.3), lineWidth: 1)
                                    )
                                    .shadow(color: Theme.buttonGlow, radius: 6, x: 0, y: 0)

                                Image(systemName: themeManager.currentTheme == .light ? "sun.max.fill" : "moon.fill")
                                    .font(.system(size: 20))
                                    .foregroundStyle(themeManager.currentTheme == .light ? .orange : Theme.primaryText)
                                    .contentTransition(.symbolEffect(.replace))
                            }
                        }
                        .sensoryFeedback(.impact(flexibility: .soft), trigger: themeManager.currentTheme)
                        Spacer()
                    }
                    .padding(.bottom, 32)
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
    case crew
    case earnings
    case chat
    case profile

    var title: String {
        switch self {
        case .feed: return "Feed"
        case .discover: return "Discover"
        case .calendar: return "My Calendar"
        case .crew: return "Find Your Crew"
        case .earnings: return "Earnings"
        case .chat: return "Chat"
        case .profile: return "Profile"
        }
    }

    static func pages(for role: UserRole) -> [AppPage] {
        switch role {
        case .customer:
            return [.feed, .discover, .crew, .chat, .profile]
        case .host:
            return [.feed, .calendar, .crew, .earnings, .chat, .profile]
        }
    }
}
