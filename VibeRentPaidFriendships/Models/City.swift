import Foundation

nonisolated struct City: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let activeUsers: Int

    static let allCities: [City] = [
        City(id: "nyc", name: "New York City", activeUsers: 2847),
        City(id: "la", name: "Los Angeles", activeUsers: 2134),
        City(id: "chi", name: "Chicago", activeUsers: 1567),
        City(id: "hou", name: "Houston", activeUsers: 989),
        City(id: "phx", name: "Phoenix", activeUsers: 876),
        City(id: "phi", name: "Philadelphia", activeUsers: 834),
        City(id: "sa", name: "San Antonio", activeUsers: 721),
        City(id: "sd", name: "San Diego", activeUsers: 698),
        City(id: "dal", name: "Dallas", activeUsers: 645),
        City(id: "sj", name: "San Jose", activeUsers: 612),
        City(id: "aus", name: "Austin", activeUsers: 1203),
        City(id: "jax", name: "Jacksonville", activeUsers: 445),
        City(id: "virtual", name: "Virtual Only", activeUsers: 5432)
    ]
}
