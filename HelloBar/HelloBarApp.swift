import SwiftUI

@main
struct HelloBarApp: App {
    @State private var status: BarStatus = .idle
    @State private var lastUpdated = Date();
    
    var body: some Scene {
        MenuBarExtra {
            ContentView(status: $status, lastUpdated: $lastUpdated) //pass a writable
        } label: {
            TimeMenuBarLabel(status: status) //pass read-only
        }
    }
}
