import SwiftUI

struct ContentView: View {
    @Binding var status: BarStatus
    @Binding var lastUpdated: Date
    @Binding var showsMenuBarIcon: Bool
    @Binding var showsMenuBarTime: Bool
    @Binding var showsMenuBarStatus: Bool
    @Binding var showsMenuBarProgress: Bool
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
            
            selectedPanelSection
            
            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding()
        .frame(width: 220)
    }
    
    @ViewBuilder
        private var selectedPanelSection: some View {
            switch selectedPanel {
            case .overview:
                overviewSection
            case .metrics:
                metricsSection
            case .settings:
                settingsSection
            }
        }
    
    private func menuBarVisibilityBinding( //if the user turns something off, only allow it when more than one item is currently enabled
        for setting: Binding<Bool>
    ) -> Binding<Bool> {
        Binding(
            get: {
                setting.wrappedValue
            },
            set: { newValue in
                if newValue || enabledMenuBarItemCount > 1 {
                    setting.wrappedValue = newValue
                }
            }
        )
    }
    
    private var enabledMenuBarItemCount: Int {
        [
            showsMenuBarIcon,
            showsMenuBarTime,
            showsMenuBarStatus,
            showsMenuBarProgress
        ].filter { $0 }.count
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
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Current Status")
                    .font(.headline)

                Picker("Status", selection: $status) {
                    ForEach(BarStatus.allCases) { status in
                        Label(status.rawValue, systemImage: status.symbolName)
                            .tag(status)
                    }
                }
                .pickerStyle(.inline)
                .labelsHidden()
                .onChange(of: status) {
                    lastUpdated = Date()
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("Shown in Menu Bar")
                    .font(.headline)

                Toggle("Icon", isOn: menuBarVisibilityBinding(for: $showsMenuBarIcon))
                Toggle("Time", isOn: menuBarVisibilityBinding(for: $showsMenuBarTime))
                Toggle("Status", isOn: menuBarVisibilityBinding(for: $showsMenuBarStatus))
                Toggle("Progress Value", isOn: menuBarVisibilityBinding(for: $showsMenuBarProgress))
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
