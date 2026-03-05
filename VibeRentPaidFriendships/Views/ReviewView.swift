import SwiftUI

struct ReviewView: View {
    let booking: Booking
    let onSubmit: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var rating: Int = 0
    @State private var reviewText: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 16) {
                        AvatarView(name: booking.hostName, size: 70, userId: booking.hostId)

                        Text("How was your hang with \(booking.hostName)?")
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)

                        Text(booking.duration.label + " \u{2022} " + booking.city)
                            .font(.subheadline)
                            .foregroundStyle(Theme.secondaryText)
                    }
                    .padding(.top, 24)

                    VStack(spacing: 12) {
                        Text("Your Rating")
                            .font(.subheadline.bold())
                            .foregroundStyle(Theme.secondaryText)

                        HStack(spacing: 12) {
                            ForEach(1...5, id: \.self) { star in
                                Button {
                                    rating = star
                                } label: {
                                    Image(systemName: star <= rating ? "star.fill" : "star")
                                        .font(.system(size: 32))
                                        .foregroundStyle(star <= rating ? Theme.accentRed : Theme.secondaryText)
                                }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tell us about it")
                            .font(.subheadline.bold())
                            .foregroundStyle(Theme.secondaryText)

                        TextField("What made this hang great?", text: $reviewText, axis: .vertical)
                            .lineLimit(4...8)
                            .padding(16)
                            .background(Theme.cardBackground)
                            .clipShape(.rect(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Theme.border, lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 16)

                    HStack(spacing: 8) {
                        Image(systemName: "info.circle")
                            .font(.caption)
                        Text("Both parties must leave a review before the next booking unlocks.")
                            .font(.caption)
                    }
                    .foregroundStyle(Theme.secondaryText)
                    .padding(.horizontal, 16)

                    GradientButton("Submit Review", icon: "paperplane.fill") {
                        onSubmit()
                        dismiss()
                    }
                    .padding(.horizontal, 16)
                    .opacity(rating > 0 && !reviewText.isEmpty ? 1 : 0.4)
                    .disabled(rating == 0 || reviewText.isEmpty)

                    Spacer(minLength: 40)
                }
            }
            .background(Theme.background)
            .navigationTitle("Leave a Review")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Later") { dismiss() }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
