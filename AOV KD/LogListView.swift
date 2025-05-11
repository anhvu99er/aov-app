import SwiftUI

struct LogListView: View {
    @EnvironmentObject var logStore: LogStore

    var body: some View {
        ScrollView {
            VStack(spacing: 2) {
                ForEach(latestLogs.keys.sorted(by: >), id: \.self) { dateKey in
                    if let log = latestLogs[dateKey] {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("🗓️ Nhật trình ngày \(dateKey)")
                                .font(.headline)

                            VStack(alignment: .leading, spacing: 12) {
                                HStack(alignment: .top, spacing: 8) {
                                    Text("🌞 Sáng")
                                        .font(.caption)
                                        .bold()
                                        .frame(width: 60, alignment: .leading)
                                    HStack(alignment: .center, spacing: 4) {
    Text(log.morning.task.isEmpty ? "—" : log.morning.task)
        .font(.subheadline)
        .lineLimit(1)
        .truncationMode(.tail)
    Spacer()
    Text("🕒 \(calculateHourText(start: log.morning.start, end: log.morning.end))")
        .font(.caption2)
        .foregroundColor(.gray)
}
                                }
                                HStack(alignment: .top, spacing: 8) {
                                    Text("🌤️ Trưa")
                                        .font(.caption)
                                        .bold()
                                        .frame(width: 60, alignment: .leading)
                                    HStack(alignment: .center, spacing: 4) {
    Text(log.afternoon.task.isEmpty ? "—" : log.afternoon.task)
        .font(.subheadline)
        .lineLimit(1)
        .truncationMode(.tail)
    Spacer()
    Text("🕒 \(calculateHourText(start: log.afternoon.start, end: log.afternoon.end))")
        .font(.caption2)
        .foregroundColor(.gray)
}
                                }
                                HStack(alignment: .top, spacing: 8) {
                                    Text("🌙 Chiều")
                                        .font(.caption)
                                        .bold()
                                        .frame(width: 60, alignment: .leading)
                                    HStack(alignment: .center, spacing: 4) {
    Text(log.evening.task.isEmpty ? "—" : log.evening.task)
        .font(.subheadline)
        .lineLimit(1)
        .truncationMode(.tail)
    Spacer()
    Text("🕒 \(calculateHourText(start: log.evening.start, end: log.evening.end))")
        .font(.caption2)
        .foregroundColor(.gray)
}
                                }
                            }
                        }
                        .padding(8)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    }
                }
            }
            .padding([.top, .horizontal], 8)
        }
        .navigationTitle("Thông tin nhật trình")
    }

    var latestLogs: [String: VehicleLog] {
        var dict: [String: VehicleLog] = [:]
        for log in logStore.logs {
            let key = formattedDate(log.date)
            dict[key] = log
        }
        return dict
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }

    func calculateHourText(start: Date, end: Date) -> String {
        let interval = Int(end.timeIntervalSince(start))
        guard interval > 0 else { return "0:00p" }
        let hours = interval / 3600
        let minutes = (interval % 3600) / 60
        return String(format: "%d:%02dp", hours, minutes)
    }
}
