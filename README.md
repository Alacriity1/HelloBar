# HelloBar

A small macOS menu bar app built with SwiftUI. Just a playground for learning, doing whatever.

## Screenshot

<img src="docs/screenshots/hellobar.png" alt="HelloBar menu bar popover" width="420">

Older screenshots live in [docs/screenshots/history](docs/screenshots/history). The screenshot workflow is documented in [docs/screenshots/README.md](docs/screenshots/README.md).

## Run

Open `HelloBar.xcodeproj` in Xcode, select the `HelloBar` scheme, and press `Cmd+R`.

## Structure

```text
HelloBar/
  HelloBarApp.swift        App entry point and menu bar scene
  ContentView.swift        Activity popover
  TimeMenuBarLabel.swift   Menu bar label
  BarStatus.swift          Status enum and symbols
  BarMetrics.swift         Sample and refreshed metric data
  Assets.xcassets/         App assets

docs/
  distribution/            Packaging example files
  screenshots/             Current and archived screenshots
```

## License

MIT
