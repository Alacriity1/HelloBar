import Foundation

struct MetricHistory {
    var values: [Double]

    static let sample = MetricHistory(
        values: [0.12, 0.28, 0.2, 0.45, 0.62, 0.4, 0.76, 0.58, 0.33, 0.7]
    )

    var latest: Double {
        values.last ?? 0
    }

    var peak: Double {
        values.max() ?? 0
    }

    var average: Double {
        guard !values.isEmpty else {
            return 0
        }

        return values.reduce(0, +) / Double(values.count)
    }

    mutating func append(_ value: Double, limit: Int = 20) {
        values.append(value)

        if values.count > limit {
            values.removeFirst(values.count - limit)
        }
    }
}
