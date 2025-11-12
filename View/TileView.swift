import SwiftUI

struct TileView: View {
    @EnvironmentObject var settings: SettingsStore
    @EnvironmentObject var data: MockDataService

    let tile: TileSpec
    var onTap: () -> Void

    var valueIntentColor: Color {
        guard let r = data.readings[tile.id], let v = r.value else { return settings.activeSkin.textMuted }
        if let c = tile.critThreshold, v >= c { return Color(hex:"#E53935") }
        if let w = tile.warnThreshold, v >= w { return Color(hex:"#FFA726") }
        return settings.activeSkin.secondary
    }

    var body: some View {
        VStack(spacing: 6) {
            // header
            HStack {
                Text(tile.name.uppercased())
                    .font(.caption2).foregroundColor(settings.activeSkin.textMuted)
                Spacer()
                if let status = data.readings[tile.id]?.status {
                    HStack(spacing: 4) {
                        Circle().fill(statusColor(status)).frame(width: 6, height: 6)
                        Text(status).font(.caption2)
                    }
                    .padding(.horizontal, 6).padding(.vertical, 3)
                    .background(Color.white.opacity(0.05)).cornerRadius(6)
                }
            }

            // big value
            if let r = data.readings[tile.id] {
                VStack(spacing: 2) {
                    Text(formattedValue(r))
                        .font(.system(size: 48 * settings.fontScale, weight: .bold, design: .rounded))
                        .foregroundStyle(valueIntentColor)
                        .lineLimit(1).minimumScaleFactor(0.5)
                    if let u = r.unit {
                        Text(u).font(.system(size: 14 * settings.fontScale))
                            .foregroundColor(settings.activeSkin.textMuted)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                Text("—")
                    .font(.system(size: 48 * settings.fontScale, weight: .bold, design: .rounded))
                    .foregroundColor(settings.activeSkin.textMuted)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            // footer
            Text(updatedText())
                .font(.caption2).foregroundColor(settings.activeSkin.textMuted.opacity(0.8))
        }
        .padding(12)
        .frame(minHeight: 120)
        .background(settings.activeSkin.tileBg)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.08)))
        .contentShape(Rectangle())
        .onTapGesture { onTap() }
    }

    func statusColor(_ s: String) -> Color {
        switch s {
        case "Live": return .green
        case "Stale": return .orange
        case "Error": return .red
        default: return .gray
        }
    }

    func formattedValue(_ r: TileReading) -> String {
        if let v = r.value {
            return v == floor(v) ? String(format: "%.0f", v) : String(format: "%.1f", v)
        }
        return r.stringValue ?? "—"
    }

    func updatedText() -> String {
        guard let ts = data.readings[tile.id]?.timestamp else { return "Updated —" }
        let f = DateFormatter(); f.dateFormat = "HH:mm:ss"
        return "Updated \(f.string(from: ts))"
    }
}
