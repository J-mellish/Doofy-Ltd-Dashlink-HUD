import SwiftUI

struct DetailDrawerView: View {
    @EnvironmentObject var settings: SettingsStore
    @EnvironmentObject var data: MockDataService
    @EnvironmentObject var history: HistoryStore

    let tile: TileSpec
    var current: TileReading? { data.readings[tile.id] }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(tile.name).font(.title2.bold())
                    Text(tile.description).font(.callout).foregroundColor(settings.activeSkin.textMuted)
                }
                Spacer()
                if let r = current {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(valueText(r)).font(.title.bold())
                            .foregroundStyle(settings.activeSkin.secondary)
                        if let u = r.unit {
                            Text(u).font(.headline).foregroundColor(settings.activeSkin.textMuted)
                        }
                    }
                }
            }

            // sparkline (1h)
            Sparkline(color: settings.activeSkin.secondary, series: history.series(id: tile.id))

            // stats
            if let s = history.stats(id: tile.id), let u = current?.unit {
                HStack {
                    statBox("Min", s.min, unit: u)
                    statBox("Avg", s.avg, unit: u)
                    statBox("Max", s.max, unit: u)
                }
            }

            HStack {
                Text("Source: Mock (Simulated)").font(.footnote).foregroundColor(settings.activeSkin.textMuted)
                Spacer()
                Text("Last updated \(timeText())").font(.footnote).foregroundColor(settings.activeSkin.textMuted)
            }
            .padding(.top, 8)

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(settings.activeSkin.appBg)
        .presentationDetents([.fraction(0.75), .large])
    }

    func valueText(_ r: TileReading) -> String {
        if let v = r.value { return String(format: v == floor(v) ? "%.0f" : "%.1f", v) }
        return r.stringValue ?? "—"
    }

    func timeText() -> String {
        guard let ts = current?.timestamp else { return "—" }
        let f = DateFormatter(); f.dateFormat = "HH:mm:ss"; return f.string(from: ts)
    }

    func statBox(_ label: String, _ v: Double, unit: String) -> some View {
        VStack {
            Text(label).font(.caption).foregroundColor(settings.activeSkin.textMuted)
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(String(format: v == floor(v) ? "%.0f" : "%.1f", v)).font(.headline.bold())
                Text(unit).font(.caption).foregroundColor(settings.activeSkin.textMuted)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct Sparkline: View {
    let color: Color
    let series: [(Date, Double)]

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let vals = series.map{$0.1}
            let minV = vals.min() ?? 0
            let maxV = vals.max() ?? 1
            let range = max(1e-6, maxV - minV)
            let pts: [CGPoint] = series.enumerated().map { i, p in
                let x = CGFloat(Double(i) / max(1.0, Double(series.count - 1))) * w
                let y = h - CGFloat((p.1 - minV) / range) * h
                return CGPoint(x: x, y: y)
            }

            ZStack {
                // baseline
                Path { p in
                    p.move(to: CGPoint(x: 0, y: h - 1))
                    p.addLine(to: CGPoint(x: w, y: h - 1))
                }.stroke(Color.white.opacity(0.1), lineWidth: 1)

                // area
                Path { p in
                    guard let first = pts.first else { return }
                    p.move(to: CGPoint(x: first.x, y: h))
                    for pt in pts { p.addLine(to: pt) }
                    p.addLine(to: CGPoint(x: pts.last?.x ?? w, y: h))
                }.fill(color.opacity(0.2))

                // line
                Path { p in
                    guard let first = pts.first else { return }
                    p.move(to: first)
                    for pt in pts.dropFirst() { p.addLine(to: pt) }
                }.stroke(color, lineWidth: 2)
            }
        }
        .frame(height: 180)
        .background(Color.white.opacity(0.03))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
