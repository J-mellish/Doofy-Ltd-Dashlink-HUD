// Views/HUDView.swift
import SwiftUI

struct HUDView: View {
    var body: some View {
        Text("HUD").padding()
    }
    @EnvironmentObject var settings: SettingsStore
    @EnvironmentObject var data: MockDataService

    @State private var selectedTile: TileSpec?
    @State private var showDrawer = false

    var cols: [GridItem] = Array(repeating: .init(.flexible(), spacing: 12), count: 3)

    var body: some View {
        ZStack {
            settings.activeSkin.appBg.ignoresSafeArea()
            VStack(spacing: 8) {
                TopBarView { preset in settings.activePreset = preset }
                ScrollView {
                    LazyVGrid(columns: cols, spacing: 12) {
                        ForEach(settings.activePreset.tileIDs.indices, id: \.self) { i in
                            let id = settings.activePreset.tileIDs[i]
                            if let tile = TILE_CATALOG.first(where: {$0.id == id}) {
                                TileView(tile: tile) {
                                    selectedTile = tile
                                    showDrawer = true
                                }
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(settings.activeSkin.tileBg.opacity(0.3))
                                    .frame(minHeight: 120)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
                Text("Tip: Tap any tile for details. Swipe down to close.")
                    .font(.footnote).foregroundColor(settings.activeSkin.textMuted)
                    .padding(.vertical, 6)
            }
        }
        .sheet(isPresented: $showDrawer) {
            if let tile = selectedTile { DetailDrawerView(tile: tile) }
        }
        .scaleEffect(x: settings.mirror ? -1 : 1, y: 1, anchor: .center)
        .environment(\.layoutDirection, .leftToRight) // keep text readable
    }
}


