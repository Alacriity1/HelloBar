import SwiftUI

struct ContentView: View {
    @Binding var status: BarStatus
    
    var body: some View {
        VStack {
            Text("HelloBar")
                .font(.headline)

            Text("Current time shown in menu bar")

            Divider()
            
            Picker("Status", selection: $status) {
                ForEach(BarStatus.allCases, id: \.self) { status in
                    Label(status.rawValue, systemImage: status.symbolName)
                        .tag(status)
                }
            }
            .pickerStyle(.inline)
            
            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding()
        .frame(width: 220)
    }
}
