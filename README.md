# HelloBar

A small macOS menu bar app built with SwiftUI. Just a playground for learning, doing whatever.

## Screenshot

<img src="docs/screenshots/hellobar.png" alt="HelloBar menu bar popover" width="420">

Older screenshots live in [docs/screenshots/history](docs/screenshots/history).

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
  BarMetrics.swift         Sample and refreshed metric data
  UsageMetric.swift        Usage model and derived values

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
