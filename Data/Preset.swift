import Foundation

enum BuiltInPresetID {
    static let driving = "driving-classic"
    static let sailing = "sailing-classic"
    static let flying  = "flying-classic"
}

let PRESETS: [ModePreset] = [
    .init(id: BuiltInPresetID.driving, name: "Driving Classic",
          tileIDs: [
            EssentialTileID.speed,
            EssentialTileID.tbt,
            EssentialTileID.heading,
            EssentialTileID.oTemp,
            EssentialTileID.cTemp,
            EssentialTileID.humidity
          ],
          skinID: StarterSkinID.gaugeDark),
    .init(id: BuiltInPresetID.sailing, name: "Sailing Classic",
          tileIDs: [
            EssentialTileID.speed,     // fallback for boat-speed
            EssentialTileID.windSpeed,
            EssentialTileID.windDir,
            EssentialTileID.heading,
            EssentialTileID.oTemp,     // fallback for water-temp
            EssentialTileID.humidity
          ],
          skinID: StarterSkinID.gaugeDark),
    .init(id: BuiltInPresetID.flying, name: "Flying Classic",
          tileIDs: [
            EssentialTileID.speed,
            EssentialTileID.altitude,
            EssentialTileID.heading,
            EssentialTileID.vsi,
            EssentialTileID.oTemp,
            EssentialTileID.cTemp
          ],
          skinID: StarterSkinID.gaugeDark)
]
