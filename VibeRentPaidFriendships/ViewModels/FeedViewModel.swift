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
            return posts.sorted { $0.createdAt > $1.createdAt }
        }
        return posts.filter { $0.city == selectedCity }.sorted { $0.createdAt > $1.createdAt }
    }

    func toggleLike(for postId: String) {
        guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }
        posts[index].isLiked.toggle()
        posts[index].likeCount += posts[index].isLiked ? 1 : -1
    }

    func addPost(_ post: FeedPost) {
        posts.insert(post, at: 0)
    }

    func addComment(to postId: String, comment: FeedPost.Comment) {
        guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }
        posts[index].comments.append(comment)
        posts[index].commentCount += 1
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

    func postsForUser(_ userId: String) -> [FeedPost] {
        posts.filter { $0.authorId == userId }.sorted { $0.createdAt > $1.createdAt }
    }
}
