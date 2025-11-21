import SwiftUI
import Combine
import Presets
struct TopBarView: View {
    @EnvironmentObject var settings: SettingsStore
    var onChangePreset: (ModePreset) -> Void

    var body: some View {
        HStack(spacing: 10) {
            // Mode (never hide)
            Menu {
                Section("Built-in") {
                    ForEach(PRESETS) { p in
                        Button(p.name) {
                            settings.activePreset = p
                            onChangePreset(p)
                        }
                    }
                }
            } label: {
                HStack {
                    Text("Mode: \(settings.activePreset.name)").font(.subheadline.bold())
                    Image(systemName: "chevron.down").font(.caption)
                }
                .padding(8).background(Color.white.opacity(0.05)).cornerRadius(8)
            }

            Spacer()

            // Units (never hide)
            HStack(spacing: 6) {
                Text("Units").foregroundColor(settings.activeSkin.textMuted).font(.footnote)
                Picker("", selection: Binding(
                    get: { settings.unitsSpeed == "km/h" ? "metric" : "imperial" },
                    set: { $0 == "metric" ? settings.setUnitsMetric() : settings.setUnitsImperial() }
                )) {
                    Text("Metric").tag("metric")
                    Text("Imperial").tag("imperial")
                }
                .pickerStyle(.segmented).frame(width: 160)
            }

            // Data source pill
            Text("Mock (Simulated)")
                .font(.footnote).padding(.horizontal, 8).padding(.vertical, 4)
                .background(Color.white.opacity(0.05)).cornerRadius(8)

            // Font scale (hidden on compact phones)
            HStack(spacing: 6) {
                Text("Font").foregroundColor(settings.activeSkin.textMuted).font(.footnote)
                Slider(value: $settings.fontScale, in: 0.85...1.5, step: 0.05)
                    .frame(width: 120)
            }.hiddenIfCompactWidth()

            // Mirror toggle
            Button { settings.mirror.toggle() } label {
                Image(systemName: "rectangle.on.rectangle.angled")
            }
            .buttonStyle(.bordered)
        }
        .padding(.horizontal, 16).padding(.vertical, 8)
        .background(Color.black.opacity(0.2))
    }
}

fileprivate extension View {
    @ViewBuilder func hiddenIfCompactWidth() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone { self.hidden() } else { self }
    }
}
