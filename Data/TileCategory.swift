import Foundation

enum EssentialTileID {
    static let speed     = "speedometer"
    static let heading   = "heading"
    static let altitude  = "altitude"
    static let vsi       = "vertical-speed"
    static let tbt       = "turn-by-turn"
    static let windSpeed = "wind-speed"
    static let windDir   = "wind-direction"
    static let oTemp     = "outside-temp"
    static let cTemp     = "cabin-temp"
    static let humidity  = "humidity"
}

let TILE_CATALOG: [TileSpec] = [
    .init(id: EssentialTileID.speed, name: "Speed",
          category: .drivingCore, unitPrimary: "km/h",
          unitAlternates: ["mph"], warnThreshold: 110, critThreshold: 150,
          minValue: 0, maxValue: 200,
          description: "Current ground speed in large numerals."),
    .init(id: EssentialTileID.heading, name: "Heading",
          category: .navigation, unitPrimary: "°",
          unitAlternates: nil, warnThreshold: nil, critThreshold: nil,
          minValue: 0, maxValue: 360,
          description: "Cardinal direction with degrees."),
    .init(id: EssentialTileID.altitude, name: "Altitude",
          category: .navigation, unitPrimary: "m",
          unitAlternates: ["ft"], warnThreshold: nil, critThreshold: nil,
          minValue: -100, maxValue: 5000,
          description: "Elevation above sea level."),
    .init(id: EssentialTileID.vsi, name: "VSI",
          category: .aviation, unitPrimary: "m/s",
          unitAlternates: ["ft/min"], warnThreshold: 10, critThreshold: 20,
          minValue: -20, maxValue: 20,
          description: "Vertical speed climb/descent with spikes."),
    .init(id: EssentialTileID.tbt, name: "Navigation",
          category: .navigation, unitPrimary: "m",
          unitAlternates: ["ft"], warnThreshold: nil, critThreshold: nil,
          minValue: 0, maxValue: 2000,
          description: "Next turn arrow + distance countdown."),
    .init(id: EssentialTileID.windSpeed, name: "Wind Speed",
          category: .marine, unitPrimary: "kn",
          unitAlternates: ["m/s","km/h"], warnThreshold: 25, critThreshold: 40,
          minValue: 0, maxValue: 50,
          description: "Apparent wind velocity."),
    .init(id: EssentialTileID.windDir, name: "Wind Direction",
          category: .marine, unitPrimary: "°",
          unitAlternates: nil, warnThreshold: nil, critThreshold: nil,
          minValue: 0, maxValue: 360,
          description: "Wind direction degrees and cardinal."),
    .init(id: EssentialTileID.oTemp, name: "Outside Temp",
          category: .environment, unitPrimary: "°C",
          unitAlternates: ["°F"], warnThreshold: -10, critThreshold: 45,
          minValue: -30, maxValue: 50,
          description: "Ambient outdoor temperature."),
    .init(id: EssentialTileID.cTemp, name: "Cabin Temp",
          category: .environment, unitPrimary: "°C",
          unitAlternates: ["°F"], warnThreshold: 28, critThreshold: 35,
          minValue: 0, maxValue: 45,
          description: "Interior temperature."),
    .init(id: EssentialTileID.humidity, name: "Humidity",
          category: .environment, unitPrimary: "%",
          unitAlternates: nil, warnThreshold: 70, critThreshold: 85,
          minValue: 20, maxValue: 95,
          description: "Relative humidity percentage.")
]
``
