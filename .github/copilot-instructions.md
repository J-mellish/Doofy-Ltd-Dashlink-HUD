## Project Overview

DashLink HUD is an iOS Swift app that displays real-time telemetry data (speed, altitude, temperature, wind, etc.) in customizable tile-based layouts. It supports multiple "modes" (Driving, Sailing, Flying) with different tile presets and visual themes.

**Key stats:**
- Single target: `DashLink HUD` (bundle ID: `Doofy-Ltd.DashLink-HUD`)
- Swift 5.0 with SwiftUI
- Project file: `DashLink HUD2.0.xcodeproj`
- No external dependencies (managed directly in Xcode)

---

## Architecture: Three Data Flows

### 1. **Tile & Data Model** (`Data/` folder)
The app defines available telemetry tiles in `TILE_CATALOG` (from `Data/TileCategory.swift`):
- Each tile has: `id`, `name`, `category`, `unitPrimary`, `unitAlternates`, `warnThreshold`, `critThreshold`, `minValue`, `maxValue`.
- Example: `EssentialTileID.speed` → "Speed" tile (0–200 km/h range, 110 km/h warning, 150 km/h critical).
- Tiles are grouped by category: `.drivingCore`, `.navigation`, `.marine`, `.aviation`, `.environment`.

**Key file:** `Data/TileCategory.swift` — defines `TileSpec` (immutable tile metadata) and `TileCategory` enum.

### 2. **State & Services** (`Service/` folder)
Three `ObservableObject` stores provide app state to SwiftUI views via `@EnvironmentObject`:

- **`SettingsStore`**: User preferences & choices
  - `@Published var activePreset` — current mode (Driving/Sailing/Flying)
  - `@Published var activeSkin` — visual theme
  - `@AppStorage` keys for units (speed, temp, distance, altitude, pressure, wind)
  - Helper methods: `setDrivingUnitsMetric()`, `setAviationUnitsImperial()`, etc. (domain-specific unit presets)
  - Also stores `@Published var fontScale`, `@Published var mirror` (UI preferences)

- **`MockDataService`**: Simulates live telemetry (1 Hz timer)
  - `@Published var readings: [String: TileReading]` — tile ID → current value + unit + status
  - Publishes `.historyAppend` notifications on every tick (consumed by `HistoryStore`)
  - Uses Perlin-like noise generation (`next()` method) to simulate realistic trends

- **`HistoryStore`**: Stores 1-hour rolling window (@ 1 Hz = 3600 max points per tile)
  - `func append(_ id: String, value: Double, at date: Date)` — FIFO ring buffer
  - `func stats(id:)` → returns (min, avg, max) for a tile ID

### 3. **View Hierarchy** (`View/` folder)
SwiftUI views compose the UI and consume stores via `@EnvironmentObject`:

- **`HUDView`** — Main content (entry point after app initialization)
  - Renders active preset's tiles in a 3-column grid (`LazyVGrid`)
  - Manages `@State var selectedTile` and detail drawer modal (`sheet`)
  - **Key pattern:** Iterates `settings.activePreset.tileIDs` and looks up each tile in `TILE_CATALOG`

- **`TopBarView`** — Control bar (preset selector, units picker, data source, font scale)
  - Mode menu iterates `PRESETS` array from `Data/Preset.swift`
  - Units toggle calls `settings.setDrivingUnitsMetric()` or imperial equivalents

- **`TileView`** — Individual tile card
  - Reads `data.readings[tile.id]` for current value
  - Color-codes by intent: critical (red, $\geq$ `critThreshold`), warning (orange, $\geq$ `warnThreshold`), nominal (secondary color)
  - Displays status indicator ("Live", "Stale", "Error") with colored dot

- **`DetailDrawerView`** — Modal sheet for tile detail
  - Shows 1-hour sparkline (from `history.series(id:)`)
  - Displays min/avg/max stats (from `history.stats(id:)`)
  - Presented as `.sheet` with `.fraction(0.75)` or `.large` detents

---

## Critical Data Flow Example: Adding a New Tile

1. **Define tile metadata:** Add entry to `TILE_CATALOG` in `Data/TileCategory.swift`
   ```swift
   .init(id: "fuel-remaining", name: "Fuel", category: .drivingCore,
         unitPrimary: "L", unitAlternates: ["gal"],
         warnThreshold: 10, critThreshold: 5, minValue: 0, maxValue: 80, ...)
   ```

2. **Add mock data generator:** Update `MockDataService.value(for:)` switch statement
   ```swift
   case "fuel-remaining": return (round(next("fuel", 0, 80, 0.1, 0.2)), "L")
   ```

3. **Reference in preset:** Add `"fuel-remaining"` to a preset's `tileIDs` array in `Data/Preset.swift`
   ```swift
   tileIDs: [..., EssentialTileID.fuel, ...]  // or just add the literal string
   ```

4. **Views auto-update:** `TileView` and `DetailDrawerView` automatically display the new tile because they query `TILE_CATALOG.first(where: {$0.id == id})`.

---

## Key Project Conventions

- **File organization:** Xcode groups mirror on-disk folders (`Service/`, `View/`, `Data/`). Keep new files in the appropriate group.
- **Enum-based IDs:** Tile IDs are string constants in `EssentialTileID` enum (e.g., `EssentialTileID.speed = "speedometer"`). Use the enum to avoid typos.
- **AppStorage for persistence:** Unit preferences and UI settings use `@AppStorage("key")` — values persist across app launches.
- **Color hex notation:** `Skin` model stores colors as hex strings; `Color(hex:)` initializer (in `View/Theme.swift`) converts them to SwiftUI Colors at runtime.
- **Notification-based history:** `MockDataService` posts `Notification.Name.historyAppend` on every data tick; `HistoryStore` listens (you'd add `.onReceive()` observer in `DetailDrawerView` or elsewhere).

---

## Build & Debug Commands

**Interactive (Xcode):**
```bash
open "/Users/jamesmellish/Documents/Doofy-Ltd-Dashlink-HUD/DashLink HUD2.0.xcodeproj"
# Then run the "DashLink HUD" scheme
```

**Command-line build (Debug):**
```bash
xcodebuild -project "/Users/jamesmellish/Documents/Doofy-Ltd-Dashlink-HUD/DashLink HUD2.0.xcodeproj" \
  -target "DashLink HUD" -configuration Debug \
  -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 14' build
```

**Command-line build (Release/Archive):**
```bash
xcodebuild -project "/Users/jamesmellish/Documents/Doofy-Ltd-Dashlink-HUD/DashLink HUD2.0.xcodeproj" \
  -target "DashLink HUD" -configuration Release archive
```

---

## Editing Checklist for AI Agents

When making changes, follow this order:

1. **Modify data model** → `Data/*.swift` (e.g., add a tile or preset)
2. **Update stores** → `Service/*.swift` (e.g., add a new `@Published` property or logic)
3. **Update views** → `View/*.swift` (e.g., wire up new store properties)
4. **Search for usages** → Verify all consumers of changed APIs are updated (use grep or Xcode's Find > Find in Project)

Example: Adding a new unit-conversion preset
- Edit `SettingsStore.swift` → add `func setMyCustomUnits()` method
- Edit `TopBarView.swift` → add a button or menu option to call it

---

## Gotchas & Patterns

- **`PRESETS` vs `activePreset`:** `PRESETS` is a global array of built-in presets; `settings.activePreset` is the currently selected one. Don't confuse them.
- **Notification timing:** `MockDataService.tick()` posts history notifications *after* updating readings. If adding new observers, ensure they consume the right `Notification.Name`.
- **Grid layout:** `HUDView` uses a fixed 3-column `LazyVGrid`. If you want to change layout, be aware of tile ordering (tiles fill left-to-right, top-to-bottom).
- **Mirror mode:** `HUDView` applies `.scaleEffect(x: settings.mirror ? -1 : 1)` but keeps `.environment(\.layoutDirection, .leftToRight)` so text stays readable.
- **Status color codes:** `TileView.statusColor(_:)` maps "Live" → green, "Stale" → orange, "Error" → red. Add cases if you add new status types.

---

## Testing & CI

Currently, no XCTest target exists. If you add tests:
- Create target named `DashLink HUD Tests`
- Run with: `xcodebuild test -project <...> -scheme "DashLink HUD" -destination 'platform=iOS Simulator,name=iPhone 14'`

---

## Resources

- **Bundle ID:** `Doofy-Ltd.DashLink-HUD` (in `project.pbxproj` as `PRODUCT_BUNDLE_IDENTIFIER`)
- **Assets:** Managed via Xcode asset catalogs (`Asset.xcassets/`); no loose image files
- **Supported platforms:** iOS (primary); macOS/xrOS mentioned in project but not actively developed
