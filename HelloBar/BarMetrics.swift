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
            UsageMetric(title: "Session", usedFraction: 0.24, resetDescription: "Resets in 42m"),
            UsageMetric(title: "Daily", usedFraction: 0.61, resetDescription: "Resets in 8h")
            ]
    )
    
    static func refreshed() -> BarMetrics {
        BarMetrics(
            progress: Double.random(in: 0...1),
            load: Double.random(in: 0...1),
            eventCount: Int.random(in: 0...100),
            usage: [
                        UsageMetric(
                            title: "Session",
                            usedFraction: Double.random(in: 0...1),
                            resetDescription: "Resets in \(Int.random(in: 15...59))m",
                        ),
                        UsageMetric(
                            title: "Daily",
                            usedFraction: Double.random(in: 0...1),
                            resetDescription: "Resets in \(Int.random(in: 1...12))h",
                        )
                    ]
        )
    }
}
