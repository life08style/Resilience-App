import SwiftUI

struct AppLockView: View {
    @State private var lockedApps: Set<String> = []
    @Environment(\.presentationMode) var presentationMode
    
    let availableApps = [
        ("Instagram", "camera.fill"),
        ("TikTok", "music.note"),
        ("Twitter", "bird"),
        ("YouTube", "play.rectangle.fill"),
        ("Netflix", "film.fill"),
        ("Games", "gamecontroller.fill"),
        ("Mail", "envelope.fill"),
        ("Safari", "safari.fill")
    ]
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Select Apps to Lock during Sleep Mode")) {
                    ForEach(availableApps, id: \.0) { app in
                        HStack {
                            Image(systemName: app.1)
                                .font(.title2)
                                .frame(width: 32)
                            Text(app.0)
                                .font(.body)
                            Spacer()
                            if lockedApps.contains(app.0) {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.red)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            toggleLock(for: app.0)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("App Lock")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    func toggleLock(for appName: String) {
        if lockedApps.contains(appName) {
            lockedApps.remove(appName)
        } else {
            lockedApps.insert(appName)
        }
    }
}
