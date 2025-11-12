import Foundation

enum TileCategory: String, Codable {
    case drivingCore = "Driving Core"
    case environment = "Environment"
    case navigation  = "Navigation"
    case marine      = "Marine"
    case aviation    = "Aviation"
}

struct TileSpec: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let category: TileCategory
    let unitPrimary: String?
    let unitAlternates: [String]?
    let warnThreshold: Double?
    let critThreshold: Double?
    let minValue: Double?
    let maxValue: Double?
    let description: String
}

struct TileReading: Codable {
    let value: Double?
    let stringValue: String?
    let unit: String?
    let status: String      // Live/Loading/Stale/Error
    let timestamp: Date
}
