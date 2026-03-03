import SwiftUI

@Observable
@MainActor
class FeedViewModel {
    var posts: [FeedPost] = FeedPost.samplePosts
    var selectedCity: String = "All Cities"
    var isRefreshing: Bool = false
    var showCitySelector: Bool = false
    var showCreatePost: Bool = false

    var filteredPosts: [FeedPost] {
        if selectedCity == "All Cities" {
            return posts
        }
        return posts.filter { $0.city == selectedCity }
    }

    func toggleLike(for postId: String) {
        guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }
        posts[index].isLiked.toggle()
        posts[index].likeCount += posts[index].isLiked ? 1 : -1
    }

    func refresh() async {
        isRefreshing = true
        try? await Task.sleep(for: .seconds(1))
        isRefreshing = false
    }

    func selectCity(_ city: String) {
        selectedCity = city
        showCitySelector = false
    }
}
