import Foundation
import Combine

final class HistoryStore: ObservableObject {
    @Published private(set) var oneHour: [String: [(Date, Double)]] = [:]

    func append(_ id: String, value: Double, at date: Date) {
        var arr = oneHour[id] ?? []
        arr.append((date, value))
        if arr.count > 3600 { arr.removeFirst(arr.count - 3600) }  // 1h @1Hz
        oneHour[id] = arr
    }

    func series(id: String) -> [(Date, Double)] { oneHour[id] ?? [] }

    func stats(id: String) -> (min: Double, avg: Double, max: Double)? {
        let s = series(id: id)
        guard !s.isEmpty else { return nil }
        let vals = s.map{$0.1}
        return (vals.min()!, vals.reduce(0,+)/Double(vals.count), vals.max()!)
    }
}
