//
//  ContentView.swift
//  DashLink HUD
//
//  Created by yabi davidoff on 2025-10-30.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HUDView()
    }
}

#Preview {
    ContentView()
        .environmentObject(SettingsStore())
        .environmentObject(MockDataService())
        .environmentObject(HistoryStore())
}
