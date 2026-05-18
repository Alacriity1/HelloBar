import Foundation

enum BarPanel: String, CaseIterable, Identifiable {
    case overview = "Overview"
    case metrics = "Metrics"
    case settings = "Settings"

    var id: String {
        rawValue
    }
}
