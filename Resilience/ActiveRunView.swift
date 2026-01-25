import SwiftUI
import MapKit
import CoreLocation

struct ActiveRunView: View {
    let mode: String
    var workout: RunWorkout?
    
    @StateObject private var locationManager = LocationManager()
    @Environment(\.presentationMode) var presentationMode
    @State private var timeElapsed: TimeInterval = 0
    @State private var remainingTime: TimeInterval = 0
    @State private var isActive = false
    @State private var timer: Timer?
    @State private var showSummary = false
    @State private var isCompleted = false
    @ObservedObject var settings = UserSettings.shared
    
    // Derived metrics
    var pace: String {
        let dist = locationManager.distance
        if dist == 0 { return "--:--" }
        
        let displayDist = settings.unitSystem == .imperial ? dist * 0.621371 : dist
        let timeToUse = workout != nil ? (Double(workout!.duration * 60) - remainingTime) : timeElapsed
        let paceSeconds = timeToUse / displayDist
        let minutes = Int(paceSeconds / 60)
        let seconds = Int(paceSeconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var timeDisplay: String {
        if let _ = workout {
            // Count Down
            let minutes = Int(remainingTime / 60)
            let seconds = Int(remainingTime.truncatingRemainder(dividingBy: 60))
            return String(format: "%02d:%02d", minutes, seconds)
        } else {
            // Count Up
            let minutes = Int(timeElapsed / 60)
            let seconds = Int(timeElapsed.truncatingRemainder(dividingBy: 60))
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    var body: some View {
        ZStack {
            // Map Layer
            MapView(route: locationManager.route)
                .edgesIgnoringSafeArea(.all)
            
            // Overlay Controls
            VStack {
                // Header
                HStack {
                    Button(action: {
                        stopTimers()
                        locationManager.stopRecording()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    Spacer()
                    
                    if let workout = workout {
                        VStack(alignment: .trailing) {
                            Text("TARGET")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.red)
                                .cornerRadius(4)
                            let targetDist = settings.unitSystem == .imperial ? convertKmToMiles(workout.distance) : workout.distance
                            Text(targetDist)
                                .font(.headline)
                                .foregroundColor(.white)
                                .shadow(radius: 2)
                        }
                    }
                }
                .padding()
                .padding(.top, 40)
                
                // Metrics Card
                VStack(spacing: 10) {
                    HStack(spacing: 20) {
                        VStack {
                            Text("DISTANCE")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            let displayDist = settings.unitSystem == .imperial ? locationManager.distance * 0.621371 : locationManager.distance
                            Text(String(format: "%.2f", displayDist))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.teal)
                            Text(settings.unitSystem == .imperial ? "miles" : "km")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Divider().frame(height: 40)
                        
                        VStack {
                            Text(workout != nil ? "REMAINING" : "TIME")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            Text(timeDisplay)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(workout != nil && remainingTime < 60 ? .red : .white)
                            Text(workout != nil ? "min left" : "elapsed")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Divider().frame(height: 40)
                        
                        VStack {
                            Text("PACE")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            Text(pace)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                            Text(settings.unitSystem == .imperial ? "min/mile" : "min/km")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(16)
                .padding(.horizontal)
                
                Spacer()
                
                // Controls
                HStack(spacing: 30) {
                    if isActive {
                        Button(action: {
                            // Stop/Finish
                            finishRun()
                        }) {
                            Image(systemName: "stop.fill")
                                .font(.title2)
                                .foregroundColor(.red)
                                .frame(width: 80, height: 80)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        }
                    } else {
                        Button(action: startRun) {
                            Image(systemName: "play.fill")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .frame(width: 80, height: 80)
                                .background(Color.teal)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        }
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            if let w = workout {
                remainingTime = TimeInterval(w.duration * 60)
            }
        }
        .sheet(isPresented: $showSummary) {
            RunSummaryView(
                distance: settings.unitSystem == .imperial ? locationManager.distance * 0.621371 : locationManager.distance,
                time: workout != nil ? (Double(workout!.duration * 60) - remainingTime) : timeElapsed,
                pace: pace,
                unit: settings.unitSystem == .imperial ? "miles" : "km",
                workout: workout,
                isSuccess: isCompleted
            )
        }
    }
    
    func startRun() {
        isActive = true
        locationManager.startRecording()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if let _ = workout {
                if remainingTime > 0 {
                    remainingTime -= 1
                } else {
                    // Time's up!
                    finishRun()
                }
            } else {
                timeElapsed += 1
            }
        }
    }
    
    func stopTimers() {
        timer?.invalidate()
        timer = nil
    }
    
    func finishRun() {
        stopTimers()
        locationManager.stopRecording()
        isActive = false
        
        // Check success logic
        if let w = workout {
            // Parse target distance "5 km" -> 5.0
            let target = Double(w.distance.replacingOccurrences(of: " km", with: "")) ?? 0
            isCompleted = locationManager.distance >= target
        } else {
            isCompleted = true // Free run is always "completed"
        }
        
        showSummary = true
    }
    func convertKmToMiles(_ kmString: String) -> String {
        let components = kmString.components(separatedBy: " ")
        guard components.count >= 1, let km = Double(components[0]) else { return kmString }
        let miles = km * 0.621371
        return String(format: "%.1f miles", miles)
    }
}

// MARK: - Map View (UIViewRepresentable)
struct MapView: UIViewRepresentable {
    var route: [CLLocationCoordinate2D]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Update polyline if route changed
        if route.count > 0 {
            // Remove old overlays
            mapView.removeOverlays(mapView.overlays)
            
            // Add new polyline
            let polyline = MKPolyline(coordinates: route, count: route.count)
            mapView.addOverlay(polyline)
            
            // Optional: Center map on user is handled by tracking mode, 
            // but we could force region update here if needed.
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0) // Vibrant Strava Blue
                renderer.lineWidth = 6
                renderer.lineCap = .round
                renderer.lineJoin = .round
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}

// MARK: - Updated Summary View
struct RunSummaryView: View {
    @Environment(\.presentationMode) var presentationMode
    let distance: Double
    let time: TimeInterval
    let pace: String
    let unit: String
    var workout: RunWorkout?
    var isSuccess: Bool
    
    var formattedTime: String {
        let minutes = Int(time / 60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                if let _ = workout {
                    Text(isSuccess ? "Challenge Complete! 🏆" : "Keep Trying! 💪")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(isSuccess ? .green : .orange)
                } else {
                    Text("Run Complete! 🎉")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 20) {
                    VStack {
                        Text("Distance")
                            .foregroundColor(.gray)
                        Text(String(format: "%.2f \(unit)", distance))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    HStack(spacing: 40) {
                        VStack {
                            Text("Time")
                            .foregroundColor(.gray)
                            Text(formattedTime)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        VStack {
                            Text("Avg Pace")
                            .foregroundColor(.gray)
                            Text(pace)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
                .background(Color(UIColor.systemGray6).opacity(0.2))
                .cornerRadius(20)
                
                Button(action: {
                    // Logic to save run and mark workout as complete
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Run")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.teal)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}
