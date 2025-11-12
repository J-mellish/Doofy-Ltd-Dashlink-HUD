import SwiftUI
import Combine

@main
struct DashLink_HUDApp: App {
    @StateObject var settings = SettingsStore()
    @StateObject var data = MockDataService()
    @StateObject var history = HistoryStore()
    
    var body: some Scene {
        WindowGroup {
            HUDView()
                .environmentObject(settings)
                .environmentObject(data)
                .environmentObject(history)
                .onReceive(NotificationCenter.default.publisher(for: .historyAppend)) { notification in
                    if let (id, date, value) = notification.object as? (String, Date, Double) {
                        history.append(id, value: value, at: date)
                    }
                }
        }
    }
}
