import SwiftUI

struct SignUpView: View {
    let onComplete: () -> Void
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var bio: String = ""
    @State private var selectedCity: String = "New York City"
    @FocusState private var focusedField: Field?

    private enum Field { case name, email, phone, bio }

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        !phone.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 8) {
                        Text("Create Account")
                            .font(.system(.largeTitle, weight: .bold))
                            .foregroundStyle(.white)
                        Text("Join the VibeRent community")
                            .font(.subheadline)
                            .foregroundStyle(Theme.secondaryText)
                    }
                    .padding(.top, 24)

                    ZStack {
                        Circle()
                            .fill(Theme.buttonBackground)
                            .frame(width: 100, height: 100)

                        Image(systemName: "camera.fill")
                            .font(.title2)
                            .foregroundStyle(.white)
                    }

                    VStack(spacing: 16) {
                        fieldRow("Name", text: $name, icon: "person.fill", field: .name, keyboard: .default)
                        fieldRow("Email", text: $email, icon: "envelope.fill", field: .email, keyboard: .emailAddress)
                        fieldRow("Phone", text: $phone, icon: "phone.fill", field: .phone, keyboard: .phonePad)

                        VStack(alignment: .leading, spacing: 8) {
                            Label("City", systemImage: "location.fill")
                                .font(.subheadline.bold())
                                .foregroundStyle(Theme.secondaryText)

                            Picker("City", selection: $selectedCity) {
                                ForEach(City.allCities, id: \.name) { city in
                                    Text(city.name).tag(city.name)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(16)
                            .background(Theme.cardBackground)
                            .clipShape(.rect(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Theme.border, lineWidth: 1)
                            )
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Label("Bio", systemImage: "text.quote")
                                .font(.subheadline.bold())
                                .foregroundStyle(Theme.secondaryText)

                            TextField("Tell people about yourself...", text: $bio, axis: .vertical)
                                .lineLimit(3...6)
                                .focused($focusedField, equals: .bio)
                                .padding(16)
                                .background(Theme.cardBackground)
                                .clipShape(.rect(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Theme.border, lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 24)

                    GradientButton("Create Account", icon: "person.badge.plus") {
                        onComplete()
                    }
                    .padding(.horizontal, 24)
                    .opacity(isValid ? 1 : 0.4)
                    .disabled(!isValid)

                    Button("Already have an account? Log in") {
                        onComplete()
                    }
                    .font(.subheadline)
                    .foregroundStyle(Theme.secondaryText)

                    Spacer(minLength: 40)
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .preferredColorScheme(.dark)
    }

    private func fieldRow(_ placeholder: String, text: Binding<String>, icon: String, field: Field, keyboard: UIKeyboardType) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(placeholder, systemImage: icon)
                .font(.subheadline.bold())
                .foregroundStyle(Theme.secondaryText)

            TextField(placeholder, text: text)
                .keyboardType(keyboard)
                .textContentType(field == .email ? .emailAddress : field == .phone ? .telephoneNumber : .name)
                .focused($focusedField, equals: field)
                .padding(16)
                .background(Theme.cardBackground)
                .clipShape(.rect(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.border, lineWidth: 1)
                )
        }
    }
}
