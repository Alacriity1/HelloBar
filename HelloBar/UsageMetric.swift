import Foundation

struct UsageMetric: Identifiable {
    let title: String
    let resetDescription: String
    let usedUnits: Int
    let limitUnits: Int
    
    
    var id: String {
        title
    }
    
    var usedFraction: Double {
        guard limitUnits > 0 else {
            return 0
        }

        return Double(usedUnits) / Double(limitUnits)
    }

    var remainingUnits: Int {
        max(limitUnits - usedUnits, 0)
    }
}
