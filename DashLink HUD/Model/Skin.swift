// Models/Skin.swift
// Views/Theme.swift
import SwiftUI

extension Color {
    /// Initialize a SwiftUI Color from a hex string like "#1C1F26" or "1C1F26".
    init(hex: String) {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if s.hasPrefix("#") { s.removeFirst() }
        
        var rgb: UInt64 = 0
        Scanner(string: s).scanHexInt64(&rgb)
        
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8)  / 255.0
        let b = Double(rgb & 0x0000FF)        / 255.0
        self.init(red: r, green: g, blue: b)
    }
    
    struct Skin: Identifiable, Codable, Equatable {
        let id: String
        let name: String

        // Codable storage-friendly fields only:
        let appBgHex: String
        let tileBgHex: String
        let textHex: String
        let textMutedHex: String
        let secondaryHex: String
        
        // Computed SwiftUI colors (use our Color(hex:) initializer):
        var appBg: Color { Color(hex: appBgHex) }
        var tileBg: Color { Color(hex: tileBgHex) }
        var text: Color { Color(hex: textHex) }
        var textMuted: Color { Color(hex: textMutedHex) }
        var secondary: Color { Color(hex: secondaryHex) }
    }
}
