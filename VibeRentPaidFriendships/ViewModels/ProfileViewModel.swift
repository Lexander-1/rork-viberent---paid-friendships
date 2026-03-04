import SwiftUI

@Observable
@MainActor
class ProfileViewModel {
    var isEditing: Bool = false
    var editName: String = ""
    var editBio: String = ""
    var editCity: String = ""
    var editInterests: String = ""

    func startEditing(user: User) {
        editName = user.name
        editBio = user.bio
        editCity = user.city
        editInterests = user.interests.joined(separator: ", ")
        isEditing = true
    }

    func saveChanges(to user: inout User) {
        user.name = editName
        user.bio = editBio
        user.city = editCity
        user.interests = editInterests.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        isEditing = false
    }
}
