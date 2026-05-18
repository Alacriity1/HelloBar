import SwiftUI

@main
struct HelloBarApp: App {
    @State private var status: BarStatus = .idle
    
    var body: some Scene {
        MenuBarExtra {
            ContentView(status: $status) //pass a writable
        } label: {
            TimeMenuBarLabel(status: status) //pass read-only
        }
    }
}
