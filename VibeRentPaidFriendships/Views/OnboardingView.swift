import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var currentPage: Int = 0

    private let pages: [(icon: String, title: String, subtitle: String)] = [
        ("person.2.fill", "Real Company,\nReal Connections", "Pay to hang out with verified people in your city. Fight loneliness with genuine platonic friendship."),
        ("shield.checkmark.fill", "Verified & Safe", "Every user is ID-verified. Background checks available. AI-moderated chats. Emergency SOS built in."),
        ("sparkles", "Share Your Vibes", "Post about your hangs, discover local hosts, and build a community of real human connection.")
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        VStack(spacing: 32) {
                            Spacer()

                            ZStack {
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [Theme.gradientStart.opacity(0.3), .clear],
                                            center: .center,
                                            startRadius: 20,
                                            endRadius: 100
                                        )
                                    )
                                    .frame(width: 200, height: 200)

                                Image(systemName: page.icon)
                                    .font(.system(size: 64))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Theme.gradientStart, Theme.gradientEnd],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            }

                            VStack(spacing: 16) {
                                Text(page.title)
                                    .font(.system(.title, weight: .bold))
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.white)

                                Text(page.subtitle)
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 32)
                            }

                            Spacer()
                            Spacer()
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                VStack(spacing: 24) {
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { index in
                            Capsule()
                                .fill(index == currentPage ?
                                    AnyShapeStyle(Theme.accent) :
                                    AnyShapeStyle(Color.white.opacity(0.2)))
                                .frame(width: index == currentPage ? 24 : 8, height: 8)
                                .animation(.snappy, value: currentPage)
                        }
                    }

                    if currentPage == 2 {
                        GradientButton("Get Started", icon: "arrow.right") {
                            onComplete()
                        }
                        .padding(.horizontal, 24)
                        .transition(.scale.combined(with: .opacity))
                    } else {
                        Button {
                            withAnimation(.snappy) {
                                currentPage += 1
                            }
                        } label: {
                            Text("Next")
                                .font(.body.bold())
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.white.opacity(0.1))
                                .clipShape(.capsule)
                        }
                        .padding(.horizontal, 24)
                    }

                    if currentPage < 2 {
                        Button("Skip") {
                            onComplete()
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                }
                .padding(.bottom, 32)
                .animation(.snappy, value: currentPage)
            }
        }
        .preferredColorScheme(.dark)
    }
}
