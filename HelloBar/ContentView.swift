import SwiftUI

struct ContentView: View {
    @Binding var status: BarStatus
    @Binding var lastUpdated: Date
    @Binding var showsMenuBarIcon: Bool
    @Binding var showsMenuBarTime: Bool
    @Binding var showsMenuBarStatus: Bool
    @Binding var showsMenuBarProgress: Bool
    @Binding var usageAlertThreshold: Double
    
    @State private var selectedPanel: BarPanel = .overview
    @State private var selectedUsageMetric: UsageMetric?
    
    let metrics: BarMetrics
//    let refreshMetrics: () -> Void
    let refreshMetrics: () async -> Void
    let isRefreshingMetrics: Bool
    let metricsLoadError: String?
    let history: MetricHistory
    
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
    
    @ViewBuilder
    private var metricsSection: some View {
        if let selectedUsageMetric {
            UsageMetricDetailView(metric: selectedUsageMetric, alertThreshold: usageAlertThreshold) {
                self.selectedUsageMetric = nil
            }
        } else {
            metricsListSection
        }
    }

    
    private var metricsListSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            MetricRow(
                title: "Progress",
                value: metrics.progress.formatted(.percent.precision(.fractionLength(0)))
            )

            ProgressView(value: metrics.progress)
            MetricHistoryView(history: history)

            MetricRow(
                title: "Load",
                value: metrics.load.formatted(.percent.precision(.fractionLength(0)))
            )

            MetricRow(
                title: "Events",
                value: "\(metrics.eventCount)"
            )
            
            Divider()

            Text("Usage")
                .font(.headline)

            ForEach(metrics.usage) { usageMetric in
                Button {
                    selectedUsageMetric = usageMetric
                } label: {
                    UsageMetricRow(
                        metric: usageMetric,
                        alertThreshold: usageAlertThreshold
                    )
                }
                .buttonStyle(.plain)
            }
            
            if let metricsLoadError {
                Label(metricsLoadError, systemImage: "exclamationmark.triangle.fill")
                    .font(.caption2)
                    .foregroundStyle(.red)
            }

            Button {
                Task {
                    await refreshMetrics() //wait for the fake fetch to finish.
                }
            } label: {
                if isRefreshingMetrics {
                    Label("Refreshing...", systemImage: "arrow.triangle.2.circlepath")
                } else {
                    Label("Refresh Metrics", systemImage: "arrow.clockwise")
                }
            }
            .disabled(isRefreshingMetrics)
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
            
            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("Usage Alert")
                    .font(.headline)

                MetricRow(
                    title: "Threshold",
                    value: usageAlertThreshold.formatted(.percent.precision(.fractionLength(0)))
                )

                Slider(value: $usageAlertThreshold, in: 0.5...1.0, step: 0.05)
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

private func usageTint(for metric: UsageMetric, alertThreshold: Double) -> Color {
    let warningThreshold = alertThreshold * 0.75

    if metric.usedFraction >= alertThreshold {
        return .red
    } else if metric.usedFraction >= warningThreshold {
        return .orange
    } else {
        return .green
    }
}

struct UsageMetricRow: View {
    @State private var isShowingDetails = false
    let metric: UsageMetric
    let alertThreshold: Double
    
    private var isAlerting: Bool {
        metric.usedFraction >= alertThreshold
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(metric.title)
                    .font(.caption)
                    .fontWeight(.semibold)

                Spacer()

                Text(metric.usedFraction.formatted(.percent.precision(.fractionLength(0))))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: metric.usedFraction)
                .tint(usageTint(for: metric, alertThreshold: alertThreshold))

            Text(metric.resetDescription)
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            if isAlerting {
                Label("High usage", systemImage: "exclamationmark.triangle.fill")
                    .font(.caption2)
                    .foregroundStyle(.red)
            }
            
            Button {
                isShowingDetails.toggle()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: isShowingDetails ? "chevron.down" : "chevron.right")
                        .frame(width: 12, alignment: .center)

                    Text("Details")

                    Spacer()
                }
                .font(.caption)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isShowingDetails {
                VStack(alignment: .leading, spacing: 4) {
                    MetricRow(title: "Used", value: "\(metric.usedUnits)")
                    MetricRow(title: "Limit", value: "\(metric.limitUnits)")
                    MetricRow(title: "Remaining", value: "\(metric.remainingUnits)")
                }
            }
        }
    }
}

struct UsageMetricDetailView: View {
    let metric: UsageMetric
    let alertThreshold: Double
    let onBack: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                onBack()
            } label: {
                Label("Metrics", systemImage: "chevron.left")
            }
            .buttonStyle(.plain)
            .font(.caption)
            
            Text(metric.title)
                            .font(.headline)

                        ProgressView(value: metric.usedFraction)
                        .tint(usageTint(for: metric, alertThreshold: alertThreshold))

                        MetricRow(
                            title: "Used",
                            value: "\(metric.usedUnits)"
                        )

                        MetricRow(
                            title: "Limit",
                            value: "\(metric.limitUnits)"
                        )

                        MetricRow(
                            title: "Remaining",
                            value: "\(metric.remainingUnits)"
                        )

                        MetricRow(
                            title: "Reset",
                            value: metric.resetDescription
                        )

                        MetricRow(
                            title: "Usage",
                            value: metric.usedFraction.formatted(.percent.precision(.fractionLength(0)))
                        )
        }
        
    }

}

struct MetricHistoryView: View {
    let history: MetricHistory

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Canvas { context, size in
                guard !history.values.isEmpty else {
                    return
                }

                let barCount = history.values.count
                let spacing: CGFloat = 2
                let totalSpacing = spacing * CGFloat(max(barCount - 1, 0))
                let barWidth = max((size.width - totalSpacing) / CGFloat(barCount), 1)

                for (index, value) in history.values.enumerated() {
                    let clampedValue = min(max(value, 0), 1)
                    let height = size.height * clampedValue
                    let x = CGFloat(index) * (barWidth + spacing)
                    let y = size.height - height

                    let rect = CGRect(
                        x: x,
                        y: y,
                        width: barWidth,
                        height: height
                    )

                    context.fill(
                        Path(roundedRect: rect, cornerRadius: 2),
                        with: .color(.blue)
                    )
                }
            }
            .frame(height: 44)

            HStack {
                Text("Peak \(history.peak.formatted(.percent.precision(.fractionLength(0))))")
                Spacer()
                Text("Avg \(history.average.formatted(.percent.precision(.fractionLength(0))))")
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
    }
}
