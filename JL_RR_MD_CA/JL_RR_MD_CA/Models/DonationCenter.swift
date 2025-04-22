import Foundation
import MapKit

struct DonationCenter: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(address)
    }

    static func == (lhs: DonationCenter, rhs: DonationCenter) -> Bool {
        return lhs.name == rhs.name && lhs.address == rhs.address
    }
}
