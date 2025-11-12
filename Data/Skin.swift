// Data/Skins.swift
import SwiftUI

enum StarterSkinID {
    static let gaugeDark    = "gauge-dark"
    static let minimalWhite = "minimal-white"
    static let neonHUD      = "neon-hud"
}

let SKINS: [Skin] = [
    .init(
        id: "gauge-dark",
        name: "Gauge Dark",
        appBgHex: "#1C1F26",
        tileBgHex: "#2F3E4D",
        textHex: "#FFFFFF",
        textMutedHex: "#A3B1C2",
        secondaryHex: "#5CC3F7"
    ),
    .init(
        id: "minimal-white",
        name: "Minimal White",
        appBgHex: "#F5F7FA",
        tileBgHex: "#FFFFFF",
        textHex: "#1C1F26",
        textMutedHex: "#2F3E4D",
        secondaryHex: "#5CC3F7"
    ),
    .init(
        id: "neon-hud",
        name: "Neon HUD",
        appBgHex: "#080A0F",
        tileBgHex: "#111826",
        textHex: "#EAF6FF",
        textMutedHex: "#9FB5C8",
        secondaryHex: "#00E5FF"
    )
]
