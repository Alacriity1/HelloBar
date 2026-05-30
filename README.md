# HelloBar

A small macOS menu bar app built with SwiftUI. Just a playground for learning and doing whatever.

HelloBar grew from a tiny clock/status item into a compact dashboard with settings, mock metrics, JSON-backed startup data, usage alerts, detail views, chart history, and async refresh behavior.

## Screenshot

<img src="docs/screenshots/hellobar.png" alt="HelloBar menu bar popover" width="200">

Older screenshots live in [docs/screenshots/history](docs/screenshots/history).

## What It Does

- Shows a configurable macOS menu bar label.
- Opens a window-style menu bar popover.
- Provides Overview, Metrics, and Settings panels.
- Persists status, last-updated time, menu bar display options, and alert threshold with `@AppStorage`.
- Loads initial metrics from bundled `metrics.json`.
- Refreshes mock metrics asynchronously with a short loading state.
- Displays progress, usage limits, alert coloring, inline details, and focused detail screens.
- Tracks recent progress values and draws a small `Canvas` bar chart with peak/average stats.

## Concepts Covered

- `MenuBarExtra` app structure
- `.menuBarExtraStyle(.window)`
- `@State`, `@Binding`, and `@AppStorage`
- segmented panels/tabs
- toggles, picker, slider, buttons, and disabled/loading states
- progress bars and alert thresholds
- inline disclosure-style details and drill-down detail screens
- `Codable` JSON decoding
- custom drawing with `Canvas`
- simple metric history and derived values
- async loading with `Task`, `async`, `await`, and `Task.sleep`

## Run

Open `HelloBar.xcodeproj` in Xcode, select the `HelloBar` scheme, and press `Cmd+R`.

## Structure

```text
HelloBar/
  HelloBarApp.swift        App entry point and MenuBarExtra wiring
  ContentView.swift        Popover layout, panels, and settings
  TimeMenuBarLabel.swift   Configurable menu bar label
  BarStatus.swift          Status options and SF Symbols
  BarPanel.swift           Popover panel tabs
  BarMetrics.swift         Fallback and refreshed metric data
  UsageMetric.swift        Usage model and derived values
  MetricHistory.swift      Recent metric values and history stats
  MetricsLoader.swift      Bundled JSON loading
  metrics.json             Initial metrics data

docs/
  distribution/            Packaging example files
  screenshots/
    hellobar.png           Current README screenshot
    history/               Archived milestone screenshots
    README.md              Screenshot workflow notes

HelloBar.xcodeproj/        Xcode project
```

## License

MIT
