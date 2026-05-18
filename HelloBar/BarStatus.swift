import Foundation

enum BarStatus: String, CaseIterable, Identifiable {
    case idle = "Idle"
    case working = "Working"
    case blocked = "Blocked"
    case done = "Done"
    
    var id: String {
        rawValue
    }

    var symbolName: String {
        switch self {
        case .idle:
            return "circle"
        case .working:
            return "bolt.fill"
        case .blocked:
            return "exclamationmark.triangle.fill"
        case .done:
            return "checkmark.circle.fill"
        }
    }
}
