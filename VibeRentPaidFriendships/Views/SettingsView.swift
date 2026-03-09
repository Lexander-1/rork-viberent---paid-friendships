import SwiftUI

struct SettingsView: View {
    let appViewModel: AppViewModel
    @Binding var user: User
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteAlert: Bool = false
    @State private var showLogoutAlert: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Account") {
                    HStack {
                        Label("Email", systemImage: "envelope.fill")
                        Spacer()
                        Text(user.email)
                            .foregroundStyle(Theme.secondaryText)
                    }
                    HStack {
                        Label("Phone", systemImage: "phone.fill")
                        Spacer()
                        Text(user.phone)
                            .foregroundStyle(Theme.secondaryText)
                    }
                }

                Section("App Theme") {
                    ForEach(AppTheme.allCases, id: \.self) { theme in
                        Button {
                            appViewModel.setTheme(theme)
                            user.appTheme = theme
                        } label: {
                            HStack {
                                Circle()
                                    .fill(themePreviewColor(theme))
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )

                                Text(theme.title)
                                    .foregroundStyle(.primary)

                                Spacer()

                                if user.appTheme == theme {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.green)
                                        .fontWeight(.bold)
                                }
                            }
                        }
                    }
                }

                Section("Notifications") {
                    Toggle(isOn: $user.notificationsEnabled) {
                        Label("Push Notifications", systemImage: "bell.fill")
                    }
                    .tint(Theme.accent)

                    Toggle(isOn: $user.proximityAlertsEnabled) {
                        Label("Proximity Alerts", systemImage: "location.magnifyingglass")
                    }
                    .tint(Theme.accent)

                    if user.role == .customer {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Notification frequency depends on Host tier:")
                                .font(.caption)
                                .foregroundStyle(Theme.secondaryText)
                            Text("Free: 3/day · Pro: 10/day · Elite: Unlimited")
                                .font(.caption2)
                                .foregroundStyle(Theme.secondaryText.opacity(0.7))
                        }
                    }
                }

                Section("Safety") {
                    Toggle(isOn: $user.locationSharingEnabled) {
                        Label("Live Location Sharing", systemImage: "location.fill")
                    }
                    .tint(Theme.accent)

                    HStack {
                        Label("Emergency SOS", systemImage: "sos")
                            .foregroundStyle(Theme.dangerRed)
                        Spacer()
                        Text("Active")
                            .font(.subheadline)
                            .foregroundStyle(.green)
                    }

                    HStack {
                        Label("No-Show Reports", systemImage: "exclamationmark.triangle.fill")
                        Spacer()
                        Text("\(user.noShowCount)")
                            .font(.subheadline)
                            .foregroundStyle(user.noShowCount > 0 ? Theme.dangerRed : .green)
                    }
                }

                Section("Legal") {
                    Button { } label: {
                        Label("Terms of Service", systemImage: "doc.text")
                    }
                    Button { } label: {
                        Label("Privacy Policy", systemImage: "hand.raised.fill")
                    }
                    Button { } label: {
                        Label("Platonic Only Agreement", systemImage: "shield.fill")
                    }
                }

                Section("About") {
                    HStack {
                        Label("Version", systemImage: "info.circle")
                        Spacer()
                        Text("3.0.0")
                            .foregroundStyle(Theme.secondaryText)
                    }
                }

                Section {
                    Button("Log Out") {
                        showLogoutAlert = true
                    }
                    .foregroundStyle(Theme.dangerRed)

                    Button("Delete Account", role: .destructive) {
                        showDeleteAlert = true
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .alert("Log Out?", isPresented: $showLogoutAlert) {
                Button("Log Out", role: .destructive) {
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        appViewModel.logout()
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("You will be signed out of your account.")
            }
            .alert("Delete Account?", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) { }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This action cannot be undone. All your data will be permanently deleted.")
            }
        }
        .preferredColorScheme(.dark)
    }

    private func themePreviewColor(_ theme: AppTheme) -> Color {
        switch theme {
        case .dark: return Color(hex: 0x181818)
        case .light: return Color(hex: 0xF5F5F5)
        case .monotoneBlue: return Color(hex: 0x001F3F)
        case .monotoneRed: return Color(hex: 0x3F0000)
        case .monotoneBrown: return Color(hex: 0x3F2A1D)
        }
    }
}
