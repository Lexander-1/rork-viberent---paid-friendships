import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var notificationsEnabled: Bool = true
    @State private var locationSharing: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var showLogoutAlert: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Account") {
                    HStack {
                        Label("Email", systemImage: "envelope.fill")
                        Spacer()
                        Text("alex@example.com")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Label("Phone", systemImage: "phone.fill")
                        Spacer()
                        Text("+1 (234) 567-899")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Notifications") {
                    Toggle(isOn: $notificationsEnabled) {
                        Label("Push Notifications", systemImage: "bell.fill")
                    }
                    .tint(Theme.gradientStart)
                }

                Section("Safety") {
                    Toggle(isOn: $locationSharing) {
                        Label("Live Location Sharing", systemImage: "location.fill")
                    }
                    .tint(Theme.gradientStart)

                    HStack {
                        Label("Emergency SOS", systemImage: "sos")
                            .foregroundStyle(Theme.dangerRed)
                        Spacer()
                        Text("Active")
                            .font(.subheadline)
                            .foregroundStyle(.green)
                    }
                }

                Section("Legal") {
                    Button {
                    } label: {
                        Label("Terms of Service", systemImage: "doc.text")
                    }
                    Button {
                    } label: {
                        Label("Privacy Policy", systemImage: "hand.raised.fill")
                    }
                    Button {
                    } label: {
                        Label("Platonic Only Agreement", systemImage: "shield.fill")
                    }
                }

                Section("About") {
                    HStack {
                        Label("Version", systemImage: "info.circle")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                }

                Section {
                    Button("Log Out") {
                        showLogoutAlert = true
                    }
                    .foregroundStyle(Theme.gradientStart)

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
                Button("Log Out", role: .destructive) { }
                Button("Cancel", role: .cancel) { }
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
}
