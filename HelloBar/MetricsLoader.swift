import Foundation

enum MetricsLoader {
    static func loadBundledMetrics() throws -> BarMetrics {
        guard let url = Bundle.main.url(forResource: "metrics", withExtension: "json") else {
            throw MetricsLoaderError.fileNotFound
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(BarMetrics.self, from: data)
    }
    
    static func loadBundledMetricsOrFallback() -> BarMetrics {
        do {
            return try loadBundledMetrics()
        } catch {
            return BarMetrics.fallback
        }
    }
}

enum MetricsLoaderError: Error {
    case fileNotFound
}
