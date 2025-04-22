import Foundation
import MapKit

class DonationController: ObservableObject {
    @Published var donationCenters: [DonationCenter] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    func fetchDonationCenters(near coordinate: CLLocationCoordinate2D) {
        isLoading = true
        errorMessage = nil
        donationCenters = [] // Clear previous results

        let queries = ["church", "charity"]
        let group = DispatchGroup()
        var allCenters: [DonationCenter] = []
        var collectedError: String?

        for query in queries {
            group.enter()

            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = query
            request.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)

            let search = MKLocalSearch(request: request)
            search.start { response, error in
                if let error = error {
                    collectedError = error.localizedDescription
                } else if let mapItems = response?.mapItems {
                    let centers = mapItems.map { item in
                        DonationCenter(
                            name: item.name ?? "Unknown",
                            address: item.placemark.title ?? "No Address",
                            coordinate: item.placemark.coordinate
                        )
                    }
                    allCenters.append(contentsOf: centers)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.isLoading = false
            if let error = collectedError {
                self.errorMessage = error
            } else if allCenters.isEmpty {
                self.errorMessage = "No donation centers found."
            } else {
                // Optional: Remove duplicates based on name & address
                self.donationCenters = Array(Set(allCenters))
            }
        }
    }

    func geocodeAddress(_ address: String, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                completion(.failure(error))
            } else if let coordinate = placemarks?.first?.location?.coordinate {
                completion(.success(coordinate))
            } else {
                completion(.failure(NSError(domain: "GeocodingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to find location."])))
            }
        }
    }

    func fetchNearbyCenters(for address: String, completion: @escaping (Result<MKCoordinateRegion, Error>) -> Void) {
        geocodeAddress(address) { result in
            switch result {
            case .success(let coordinate):
                self.fetchDonationCenters(near: coordinate)
                let region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                DispatchQueue.main.async {
                    completion(.success(region))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
