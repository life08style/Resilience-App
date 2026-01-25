// TEST COMMENT: If you see this, the file is being updated.
import Foundation
import HealthKit
import Combine

final class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()
    
    @Published var isAuthorized = false
    
    private let typesToRead: Set<HKObjectType> = [
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
    ]
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                self.isAuthorized = success
            }
        }
    }
    
    func resyncData() {
        // Trigger a fresh fetch of all relevant data points
        print("Resyncing HealthKit data...")
        requestAuthorization()
        // In a real implementation, this would trigger queries for the last 7-30 days
    }
}
