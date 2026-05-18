import Foundation

struct UsageMetric: Identifiable {
    let id = UUID()
    let title: String
    let usedFraction: Double
    let resetDescription: String
}
