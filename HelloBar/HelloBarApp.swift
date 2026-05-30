import SwiftUI

@main
struct HelloBarApp: App {
    @AppStorage("barStatus") private var storedStatus = BarStatus.idle.rawValue
    @AppStorage("lastUpdated") private var storedLastUpdated = Date().timeIntervalSince1970
    @AppStorage("showsMenuBarIcon") private var showsMenuBarIcon = true
    @AppStorage("showsMenuBarTime") private var showsMenuBarTime = true
    @AppStorage("showsMenuBarStatus") private var showsMenuBarStatus = false
    @AppStorage("showsMenuBarProgress") private var showsMenuBarProgress = false
    @AppStorage("usageAlertThreshold") private var usageAlertThreshold = 0.9
    @State private var metrics = MetricsLoader.loadBundledMetricsOrFallback()
    @State private var metricsLoadError: String?
    @State private var history = MetricHistory.sample
    
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
                showsMenuBarIcon: $showsMenuBarIcon,
                showsMenuBarTime: $showsMenuBarTime,
                showsMenuBarStatus: $showsMenuBarStatus,
                showsMenuBarProgress: $showsMenuBarProgress,
                usageAlertThreshold: $usageAlertThreshold,
                metrics: metrics,
                refreshMetrics: {
                    let refreshedMetrics = BarMetrics.refreshed()
                    metrics = refreshedMetrics
                    history.append(refreshedMetrics.progress)
                    lastUpdated.wrappedValue = Date()
                },
                metricsLoadError: metricsLoadError,
                history: history
            )
        } label: {
            TimeMenuBarLabel(
                status: status.wrappedValue,
                metrics: metrics,
                showsIcon: showsMenuBarIcon,
                showsTime: showsMenuBarTime,
                showsStatus: showsMenuBarStatus,
                showsProgress: showsMenuBarProgress
            )
        }
        .menuBarExtraStyle(.window)
    }
}
