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
                        AvatarView(name: booking.hostName, size: 80, userId: booking.hostId)

                        Text("How was your hang with \(booking.hostName)?")
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)

                        Text(booking.duration.label + " \u{2022} " + booking.city)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 24)

                    VStack(spacing: 12) {
                        Text("Your Rating")
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)

                        HStack(spacing: 12) {
                            ForEach(1...5, id: \.self) { star in
                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                        rating = star
                                    }
                                } label: {
                                    Image(systemName: star <= rating ? "star.fill" : "star")
                                        .font(.system(size: 36))
                                        .foregroundStyle(star <= rating ? .yellow : .secondary)
                                        .scaleEffect(star <= rating ? 1.1 : 1.0)
                                }
                                .sensoryFeedback(.selection, trigger: rating)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tell us about it")
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)

                        TextField("What made this hang great?", text: $reviewText, axis: .vertical)
                            .lineLimit(4...8)
                            .padding(16)
                            .background(Theme.cardBackground)
                            .clipShape(.rect(cornerRadius: 12))
                    }
                    .padding(.horizontal, 16)

                    HStack(spacing: 8) {
                        Image(systemName: "info.circle")
                            .font(.caption)
                        Text("Both parties must leave a review before the next booking unlocks.")
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
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
            .background(Color.black)
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
