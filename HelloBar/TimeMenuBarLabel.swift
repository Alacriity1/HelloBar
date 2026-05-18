import SwiftUI
internal import Combine

struct TimeMenuBarLabel: View {
    @State private var now = Date()

    let status: BarStatus
    let metrics: BarMetrics
    let showsIcon: Bool
    let showsTime: Bool
    let showsStatus: Bool
    let showsProgress: Bool

    private let timer = Timer.publish(
        every: 60,
        on: .main,
        in: .common
    ).autoconnect()

    var body: some View {
        HStack(spacing: 4) {
            if showsIcon {
                Image(systemName: status.symbolName)
            }

            if showsTime {
                Text(now.formatted(date: .omitted, time: .shortened))
            }

            if showsStatus {
                Text(status.rawValue)
            }

            if showsProgress {
                Text(metrics.progress.formatted(.percent.precision(.fractionLength(0))))
            }
        }
        .fixedSize()
        .onReceive(timer) { currentTime in
            now = currentTime
        }
    }
}
