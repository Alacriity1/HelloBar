import SwiftUI

@main
struct HelloBarApp: App {
    @AppStorage("barStatus") private var storedStatus = BarStatus.idle.rawValue
    @AppStorage("lastUpdated") private var storedLastUpdated = Date().timeIntervalSince1970
    @State private var metrics = BarMetrics.sample
    
    var body: some Scene {
        let status = Binding<BarStatus>(
            get: {
                BarStatus(rawValue: storedStatus) ?? .idle
            },
            set: { newStatus in
                storedStatus = newStatus.rawValue
            }
        )
        let lastUpdated = Binding<Date>(
            get: {
                Date(timeIntervalSince1970: storedLastUpdated)
            },
            set: { newDate in
                storedLastUpdated = newDate.timeIntervalSince1970
            }
        )
        
        return MenuBarExtra {
            ContentView(
                status: status,
                lastUpdated: lastUpdated,
                metrics: metrics,
                refreshMetrics: {
                    metrics = BarMetrics.refreshed()
                    lastUpdated.wrappedValue = Date()
                }
            )
        } label: {
            TimeMenuBarLabel(status: status.wrappedValue)
        }
        .menuBarExtraStyle(.window)
    }
}
