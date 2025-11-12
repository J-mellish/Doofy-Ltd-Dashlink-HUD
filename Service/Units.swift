import Foundation

enum Units {
    static func speed(_ v: Double, from: String = "km/h", to: String) -> Double {
        var kmh = v
        if from == "mph" { kmh = v * 1.60934 }
        if from == "kn"  { kmh = v * 1.852 }
        if to == "mph" { return kmh / 1.60934 }
        if to == "kn"  { return kmh / 1.852 }
        return kmh
    }
    static func temp(_ v: Double, from: String, to: String) -> Double {
        if from == to { return v }
        if from == "°C" && to == "°F" { return v * 9/5 + 32 }
        if from == "°F" && to == "°C" { return (v - 32) * 5/9 }
        return v;
    }
}
