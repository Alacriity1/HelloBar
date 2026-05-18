import SwiftUI
internal import Combine

struct TimeMenuBarLabel: View {
    @State private var now = Date()
    let status : BarStatus

    private let timer = Timer.publish(
        every: 60,
        on: .main,
        in: .common
    ).autoconnect()

    var body: some View {
//        Text(now.formatted(date: .omitted, time: .shortened))
//            .onReceive(timer) { currentTime in
//                now = currentTime
//            }
        HStack {
            Image(systemName: status.symbolName)
            Text(now.formatted(date: .omitted, time: .shortened))
        }
        .onReceive(timer) { currentTime in
            now = currentTime
        }
    }
}
