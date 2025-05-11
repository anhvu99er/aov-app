import Foundation

class LogStore: ObservableObject {
    @Published var logs: [VehicleLog] = []

    private let key = "savedLogs"

    init() {
        load()
    }

    func add(_ log: VehicleLog) {
        logs.append(log)
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(logs) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([VehicleLog].self, from: data) {
            logs = decoded
        }
    }
}
