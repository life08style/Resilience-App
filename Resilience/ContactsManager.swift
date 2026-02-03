import Contacts
import SwiftUI
import Combine

class ContactsManager: ObservableObject {
    @Published var contacts: [CNContact] = []
    @Published var authorizationStatus: CNAuthorizationStatus = .notDetermined
    
    private let store = CNContactStore()
    
    func checkPermission() {
        authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
    }
    
    func requestAccess() {
        store.requestAccess(for: .contacts) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.authorizationStatus = granted ? .authorized : .denied
                if granted {
                    self?.fetchContacts()
                }
            }
        }
    }
    
    func fetchContacts() {
        guard authorizationStatus == .authorized else { return }
        
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactThumbnailImageDataKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        DispatchQueue.global(qos: .userInitiated).async {
            var fetchedContacts: [CNContact] = []
            
            do {
                try self.store.enumerateContacts(with: request) { contact, stop in
                    fetchedContacts.append(contact)
                }
                
                DispatchQueue.main.async {
                    self.contacts = fetchedContacts.sorted { $0.givenName < $1.givenName }
                }
            } catch {
                print("Failed to fetch contacts: \(error)")
            }
        }
    }
}
