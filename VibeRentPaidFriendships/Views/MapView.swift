import SwiftUI
import MapKit

struct MapTabView: View {
    let users: [User]
    let selectedCity: String
    var feedViewModel: FeedViewModel?
    var currentUserRole: UserRole = .customer
    @Binding var isDrawerOpen: Bool
    @State private var position: MapCameraPosition = .automatic
    @State private var selectedUser: User?
    @State private var showCitySelector: Bool = false

    private var visibleUsers: [User] {
        users.filter { user in
            !user.isGhostMode &&
            user.latitude != nil &&
            user.longitude != nil &&
            (selectedCity == "All Cities" || user.city == selectedCity)
        }
    }

    private var cityCoordinate: CLLocationCoordinate2D {
        let cityCoords: [String: (lat: Double, lon: Double)] = [
            "New York City": (40.7128, -74.0060),
            "Los Angeles": (34.0522, -118.2437),
            "Chicago": (41.8781, -87.6298),
            "Houston": (29.7604, -95.3698),
            "Phoenix": (33.4484, -112.0740),
            "Philadelphia": (39.9526, -75.1652),
            "San Antonio": (29.4241, -98.4936),
            "San Diego": (32.7157, -117.1611),
            "Dallas": (32.7767, -96.7970),
            "San Jose": (37.3382, -121.8863),
            "Austin": (30.2672, -97.7431),
            "Jacksonville": (30.3322, -81.6557)
        ]
        if let coords = cityCoords[selectedCity] {
            return CLLocationCoordinate2D(latitude: coords.lat, longitude: coords.lon)
        }
        return CLLocationCoordinate2D(latitude: 39.8283, longitude: -98.5795)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Map(position: $position) {
                    ForEach(visibleUsers, id: \.id) { user in
                        Annotation(user.name, coordinate: CLLocationCoordinate2D(
                            latitude: user.latitude ?? 0,
                            longitude: user.longitude ?? 0
                        )) {
                            Button {
                                selectedUser = user
                            } label: {
                                VStack(spacing: 2) {
                                    AvatarView(name: user.name, size: 36, userId: user.id, isVerified: user.isVerified)
                                        .shadow(color: Theme.accentRed.opacity(0.5), radius: 6, y: 0)
                                    Text(user.name.split(separator: " ").first.map(String.init) ?? user.name)
                                        .font(.caption2.bold())
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Theme.cardBackground.opacity(0.9))
                                        .clipShape(.capsule)
                                }
                            }
                        }
                    }
                }
                .mapStyle(.standard(elevation: .flat, pointsOfInterest: .excludingAll))

                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.caption)
                        .foregroundStyle(Theme.secondaryText)
                    Text("Live users in \(selectedCity)")
                        .font(.caption)
                        .foregroundStyle(Theme.secondaryText)
                    Text("·")
                        .foregroundStyle(Theme.secondaryText)
                    Text("Ghost Mode hides you")
                        .font(.caption)
                        .foregroundStyle(Theme.secondaryText.opacity(0.7))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial)
                .clipShape(.capsule)
                .padding(.bottom, 16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button {
                        showCitySelector = true
                    } label: {
                        HStack(spacing: 6) {
                            Text(selectedCity)
                                .font(.headline)
                                .foregroundStyle(.white)
                            Image(systemName: "chevron.down")
                                .font(.caption.bold())
                                .foregroundStyle(Theme.secondaryText)
                        }
                    }
                }

                HamburgerButton(isDrawerOpen: $isDrawerOpen)
            }
            .sheet(item: $selectedUser) { user in
                NavigationStack {
                    HostProfileView(host: user, viewerRole: currentUserRole)
                }
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            }
            .fullScreenCover(isPresented: $showCitySelector) {
                CitySelectorView(selectedCity: selectedCity) { city in
                    feedViewModel?.selectCity(city)
                    showCitySelector = false
                }
            }
            .onAppear {
                updateCameraPosition()
            }
            .onChange(of: selectedCity) { _, _ in
                updateCameraPosition()
            }
        }
    }

    private func updateCameraPosition() {
        let span = selectedCity == "All Cities"
            ? MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 40)
            : MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        position = .region(MKCoordinateRegion(center: cityCoordinate, span: span))
    }
}
