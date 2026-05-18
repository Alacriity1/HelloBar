import SwiftUI

struct ContentView: View {
    @Binding var status: BarStatus
    @Binding var lastUpdated: Date
    
    let metrics: BarMetrics
    let refreshMetrics: () -> Void
    
    var body: some View {
        VStack {
            Text("Activity")
                .font(.headline)
            
            MetricRow(
                title: "Progress",
                value: metrics.progress.formatted(.percent.precision(.fractionLength(0)))
            )
            
            ProgressView(value: metrics.progress)
            
            MetricRow(
                    title: "Load",
                    value: metrics.load.formatted(.percent.precision(.fractionLength(0)))
            )
            
            MetricRow(
                    title: "Events",
                    value: "\(metrics.eventCount)"
            )
            
            Button("Refresh Metrics") {
                    refreshMetrics()
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

struct MetricRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            
            Spacer()
            
            Text(value)
                .foregroundStyle(.secondary)
        }
        .font(.caption)
    }
}
