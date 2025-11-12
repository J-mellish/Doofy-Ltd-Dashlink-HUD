// Services/SettingsStore.swift
import SwiftUI
import Combine
@main
struct DashLink_HUDApp: App {
    @StateObject var settings = SettingsStore()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
        }
    }
}
final class SettingsStore: ObservableObject {

    // Example definitions of PRESET and SKIN arrays
    let PRESET = ["Default", "Sport", "Eco"]
    let SKIN = ["Light", "Dark", "Blue"]

        // Units — AppStorage properties
        @AppStorage("units.speed")     var unitsSpeed: String = "km/h"
        @AppStorage("units.temp")      var unitsTemp: String  = "°C"
        @AppStorage("units.distance")  var unitsDistance: String = "km"

        // Marine
        @AppStorage("units.windSpeed") var unitsWindSpeed: String = "kn"

        // Aviation
        @AppStorage("units.altitude")  var unitsAltitude: String = "m"
        @AppStorage("units.pressure")  var unitsPressure: String = "hPa"
    // If you ever used a different name (e.g., unitsAirPressure), either rename usages or add:
    // @AppStorage("units.airPressure") var unitsAirPressure: String = "hPa"

    // ---- Simple helpers (optional) ----
    func setDrivingUnitsMetric() {
        unitsSpeed    = "km/h"
        unitsTemp     = "°C"
        unitsDistance = "km"
    }
    func setDrivingUnitsImperial() {
        unitsSpeed    = "mph"
        unitsTemp     = "°F"
        unitsDistance = "mi"
    }

    func setMarineUnitsMetric() {
        unitsSpeed     = "km/h"
        unitsTemp      = "°C"
        unitsDistance  = "km"
        unitsWindSpeed = "m/s"
    }
    func setMarineUnitsImperial() {
        unitsSpeed     = "kn"
        unitsTemp      = "°F"
        unitsDistance  = "NM"
        unitsWindSpeed = "kn"
    }

    func setAviationUnitsMetric() {
        unitsSpeed     = "km/h/Mach"
        unitsPressure  = "hPa"
        unitsAltitude  = "m"
        unitsTemp      = "°C"
        unitsDistance  = "km"
    }
    func setAviationUnitsImperial() {
        unitsSpeed     = "kts/Mach"
        unitsPressure  = "inHg"     // use "Bar" if you truly want it, but inHg is typical US
        unitsAltitude  = "ft/FL"
        unitsTemp      = "°F"
        unitsDistance  = "NM/ft"
    }
}
