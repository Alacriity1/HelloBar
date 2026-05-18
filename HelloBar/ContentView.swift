import SwiftUI

struct ContentView: View {
    @Binding var status: BarStatus
    @Binding var lastUpdated: Date
    
    var body: some View {
        VStack {
            Text("HelloBar")
                .font(.headline)

            Text("Current time shown in menu bar")
            
            Text("Updated \(lastUpdated.formatted(date: .omitted, time: .shortened))")
                .font(.caption)
                .foregroundStyle(.secondary)

            Divider()
            
            Picker("Status", selection: $status) {
                ForEach(BarStatus.allCases, id: \.self) { status in
                    Label(status.rawValue, systemImage: status.symbolName)
                        .tag(status)
                }
            }
            .pickerStyle(.inline)
            .onChange(of: status) {
                lastUpdated = Date();
            }
            
            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding()
        .frame(width: 220)
    }
}
