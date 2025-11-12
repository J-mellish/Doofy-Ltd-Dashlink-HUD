import Foundation
import Combine

final class MockDataService: ObservableObject {
    @Published private(set) var readings: [String: TileReading] = [:]
    private var timer: AnyCancellable?
    private var seed: [String: Double] = [:]
    private var trend: [String: Double] = [:]

    init() { start() }

    func start() {
        timer?.cancel()
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.tick() }
    }

    private func tick() {
        let now = Date()
        for tile in TILE_CATALOG {
            let (val, unit) = value(for: tile)
            let r = TileReading(value: val,
                                stringValue: val == nil ? "—" : nil,
                                unit: unit,
                                status: "Live",
                                timestamp: now)
            readings[tile.id] = r
            if let v = val {
                NotificationCenter.default.post(name: .historyAppend, object: (tile.id, now, v))
            }
        }
    }

    private func next(_ id: String, min: Double, max: Double, drift: Double, noise: Double) -> Double {
        if seed[id] == nil { seed[id] = (min + max)/2 }
        if trend[id] == nil { trend[id] = 0 }
        var t = trend[id]! + (Double.random(in: -0.5...0.5) * drift)
        t = max(-2, min(2, t))
        var v = seed[id]! + t + Double.random(in: -0.5...0.5) * noise
        v = max(min, min(max, v))
        seed[id] = v; trend[id] = t
        return v
    }

    private func value(for tile: TileSpec) -> (Double?, String?) {
        switch tile.id {
        case EssentialTileID.speed:     return (round(next("speed", 0, 200, 0.3, 0.5)), "km/h")
        case EssentialTileID.heading:   return (round(next("heading", 0, 360, 0.2, 0.3)), "°")
        case EssentialTileID.altitude:  return (round(next("altitude", 0, 3000, 0.5, 1.0)), "m")
        case EssentialTileID.vsi:       return (round(next("vsi", -20, 20, 2.0, 4.0)), "m/s")
        case EssentialTileID.oTemp:     return (round(next("oTemp", -10, 45, 0.02, 0.10)*10)/10, "°C")
        case EssentialTileID.cTemp:     return (round(next("cTemp", 15, 30, 0.01, 0.05)*10)/10, "°C")
        case EssentialTileID.humidity:  return (round(next("humidity", 20, 80, 0.10, 0.20)), "%")
        case EssentialTileID.windSpeed: return (round(next("windSpeed", 0, 40, 0.5, 1.0)), "kn")
        case EssentialTileID.windDir:   return (round(next("windDir", 0, 360, 0.3, 0.5)), "°")
        case EssentialTileID.tbt:
            let d = max(0, (seed["tbt"] ?? 500) - Double.random(in: 5...15))
            seed["tbt"] = (d == 0 ? 800 : d)
            return (d, "m")
        default:
            return (nil, nil)
        }
    }
}

extension Notification.Name {
    static let historyAppend = Notification.Name("historyAppend")
}
