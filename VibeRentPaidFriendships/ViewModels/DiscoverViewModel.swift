import SwiftUI

@Observable
@MainActor
class DiscoverViewModel {
    var hosts: [User] = User.sampleUsers.filter { $0.isHost }
    var searchText: String = ""
    var selectedCity: String = "All Cities"
    var minRate: Double = 30
    var maxRate: Double = 100
    var verifiedOnly: Bool = false
    var showFilters: Bool = false
    var sortOption: SortOption = .recommended

    enum SortOption: String, CaseIterable {
        case recommended = "Recommended"
        case pricelow = "Price: Low"
        case pricehigh = "Price: High"
        case rating = "Top Rated"
    }

    var filteredHosts: [User] {
        var result = hosts

        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.bio.localizedCaseInsensitiveContains(searchText) ||
                $0.interests.contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
            }
        }

        if selectedCity != "All Cities" {
            result = result.filter { $0.city == selectedCity }
        }

        if verifiedOnly {
            result = result.filter { $0.isVerified }
        }

        result = result.filter { $0.hourlyRate >= minRate && $0.hourlyRate <= maxRate }

        switch sortOption {
        case .recommended:
            result.sort { lhs, rhs in
                if lhs.isFeatured != rhs.isFeatured { return lhs.isFeatured }
                if lhs.hasBackgroundCheck != rhs.hasBackgroundCheck { return lhs.hasBackgroundCheck }
                return lhs.rating > rhs.rating
            }
        case .pricelow:
            result.sort { $0.hourlyRate < $1.hourlyRate }
        case .pricehigh:
            result.sort { $0.hourlyRate > $1.hourlyRate }
        case .rating:
            result.sort { $0.rating > $1.rating }
        }

        return result
    }
}
