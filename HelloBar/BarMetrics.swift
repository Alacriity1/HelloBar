import Foundation

struct BarMetrics{
    var progress: Double
    var load: Double
    var eventCount: Int
    var usage: [UsageMetric]
    
    static let sample = BarMetrics(
        progress: 0.64,
        load: 0.42,
        eventCount: 12,
        usage: [
            UsageMetric(
                title: "Session",
                resetDescription: "Resets in 42m",
                usedUnits: 24,
                limitUnits: 100
            ),
            UsageMetric(
                title: "Daily",
                resetDescription: "Resets in 8h",
                usedUnits: 384,
                limitUnits: 500
            ),
        ]
    )
    
    static func refreshed() -> BarMetrics {
        let sessionLimit = 100
        let sessionUsed = Int.random(in: 0...sessionLimit)

        let dailyLimit = 500
        let dailyUsed = Int.random(in: 0...dailyLimit)
        return BarMetrics(
            progress: Double.random(in: 0...1),
            load: Double.random(in: 0...1),
            eventCount: Int.random(in: 0...100),
            usage: [
                UsageMetric(
                    title: "Session",
                    resetDescription: "Resets in \(Int.random(in: 15...59))m",
                    usedUnits: sessionUsed,
                    limitUnits: sessionLimit
                ),
                UsageMetric(
                    title: "Daily",
                    resetDescription: "Resets in \(Int.random(in: 1...12))h",
                    usedUnits: dailyUsed,
                    limitUnits: dailyLimit
                )
            ]
        )
    }
}
