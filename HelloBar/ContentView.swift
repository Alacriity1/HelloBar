import SwiftUI

struct ContentView: View {
    @Binding var status: BarStatus
    @Binding var lastUpdated: Date
    @State private var selectedPanel: BarPanel = .overview
    
    let metrics: BarMetrics
    let refreshMetrics: () -> Void
    
    var body: some View {
        VStack {
            Text("Activity")
                .font(.headline)
            
            Picker("Panel", selection: $selectedPanel) {
                ForEach(BarPanel.allCases) { panel in
                    Text(panel.rawValue).tag(panel)
                }
            }
            .pickerStyle(.segmented)
            
            switch selectedPanel {
                    case .overview:
                        overviewSection
                    case .metrics:
                        metricsSection
                    case .settings:
                        settingsSection
                    }            
            
            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding()
        .frame(width: 220)
    }
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            MetricRow(title: "Status", value: status.rawValue)

            MetricRow(
                title: "Updated",
                value: lastUpdated.formatted(date: .omitted, time: .shortened)
            )
        }
    }

    private var metricsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
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
        }
    }

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Picker("Status", selection: $status) {
                ForEach(BarStatus.allCases) { status in
                    Label(status.rawValue, systemImage: status.symbolName)
                        .tag(status)
                }
            }
            .pickerStyle(.inline)
            .onChange(of: status) {
                lastUpdated = Date()
            }
        }
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
