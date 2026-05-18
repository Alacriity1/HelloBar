import SwiftUI

@main
struct HelloBarApp: App {
    @AppStorage("barStatus") private var storedStatus = BarStatus.idle.rawValue
    @AppStorage("lastUpdated") private var storedLastUpdated = Date().timeIntervalSince1970
    
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
            ContentView(status: status, lastUpdated: lastUpdated)
        } label: {
            TimeMenuBarLabel(status: status.wrappedValue)
        }
    }
}
