import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocation?
    @Published var route: [CLLocationCoordinate2D] = []
    @Published var distance: Double = 0 // in km
    @Published var isRecording = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // Update every 10 meters
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startRecording() {
        isRecording = true
        route = []
        distance = 0
        locationManager.startUpdatingLocation()
    }
    
    func stopRecording() {
        isRecording = false
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        
        // Filter out old/cached locations
        if newLocation.timestamp.timeIntervalSinceNow < -5 { return }
        
        // Update current location
        self.location = newLocation
        
        if isRecording {
            // Append to route
            route.append(newLocation.coordinate)
            
            // Calculate distance if we have previous points
            if route.count > 1 {
                let previousLocation = CLLocation(latitude: route[route.count - 2].latitude, longitude: route[route.count - 2].longitude)
                let delta = newLocation.distance(from: previousLocation) / 1000.0 // Convert to km
                distance += delta
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
}
