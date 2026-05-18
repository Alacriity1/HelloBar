import Foundation

struct BarMetrics{
    var progress: Double
    var load: Double
    var eventCount: Int
    
    static let sample = BarMetrics(
        progress: 0.64,
        load: 0.42,
        eventCount: 12
    )
    
    static func refreshed() -> BarMetrics {
        BarMetrics(
            progress: Double.random(in: 0...1),
            load: Double.random(in: 0...1),
            eventCount: Int.random(in: 0...100)
        )
    }
}
