// NewLogView.swift (refactor giao diện hiện đại)

import SwiftUI

struct NewLogView: View {
    @AppStorage("driverName") private var driverName = ""
    @AppStorage("equipmentName") private var equipmentName = ""
    @AppStorage("licensePlate") private var licensePlate = ""

    @EnvironmentObject var logStore: LogStore

    @State private var date = Date()

    @State private var morningTask = ""
    @State private var morningStart = Date()
    @State private var morningEnd = Date()
    @State private var morningKmStart = ""
    @State private var morningKmEnd = ""

    @State private var afternoonTask = ""
    @State private var afternoonStart = Date()
    @State private var afternoonEnd = Date()
    @State private var afternoonKmStart = ""
    @State private var afternoonKmEnd = ""

    @State private var eveningTask = ""
    @State private var eveningStart = Date()
    @State private var eveningEnd = Date()
    @State private var eveningKmStart = ""
    @State private var eveningKmEnd = ""

    let draftKey = "todayDraftLog"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                GroupBox(label: Label("Thông tin tài xế", systemImage: "person.fill")) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("👤 \(driverName)").font(.body)
                        Text("🚜 \(equipmentName) - \(licensePlate)").font(.footnote).foregroundColor(.gray)
                    }
                }

                GroupBox(label: Label("Ngày ghi nhật trình", systemImage: "calendar")) {
                    DatePicker("Chọn ngày", selection: $date, displayedComponents: .date)
                    Text("📅 \(formattedDate(date))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                workCard(title: "🌞 Buổi sáng", task: $morningTask, start: $morningStart, end: $morningEnd, kmStart: $morningKmStart, kmEnd: $morningKmEnd)
                workCard(title: "🌤️ Buổi chiều", task: $afternoonTask, start: $afternoonStart, end: $afternoonEnd, kmStart: $afternoonKmStart, kmEnd: $afternoonKmEnd)
                workCard(title: "🌙 Buổi tối", task: $eveningTask, start: $eveningStart, end: $eveningEnd, kmStart: $eveningKmStart, kmEnd: $eveningKmEnd)

                Button(action: saveLog) {
                    Label("Lưu nhật trình", systemImage: "square.and.arrow.down")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle("Ghi nhật trình")
        .onAppear(perform: loadDraftIfToday)
        .onChange(of: anyInput) { _ in saveDraft() }
    }

    var anyInput: String {
        morningTask + morningKmStart + morningKmEnd +
        afternoonTask + afternoonKmStart + afternoonKmEnd +
        eveningTask + eveningKmStart + eveningKmEnd
    }

    func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f.string(from: date)
    }

    func calculateHourText(start: Date, end: Date) -> String {
        let i = Int(end.timeIntervalSince(start))
        guard i > 0 else { return "0:00p" }
        return String(format: "%d:%02dp", i/3600, (i%3600)/60)
    }

    func calculateKmText(start: String, end: String) -> String {
        guard let s = Double(start), let e = Double(end) else { return "0" }
        return String(format: "%.1f", max(0, e - s))
    }

    @ViewBuilder
    func workCard(title: String, task: Binding<String>, start: Binding<Date>, end: Binding<Date>, kmStart: Binding<String>, kmEnd: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline)

            TextField("Nội dung công việc", text: task)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            HStack {
                DatePicker("Bắt đầu", selection: start, displayedComponents: .hourAndMinute)
                DatePicker("Kết thúc", selection: end, displayedComponents: .hourAndMinute)
            }
            .font(.caption)

            Text("🕒 Số giờ máy: \(calculateHourText(start: start.wrappedValue, end: end.wrappedValue))")
                .foregroundColor(.blue)

            HStack {
                TextField("KM đầu", text: kmStart).keyboardType(.decimalPad)
                TextField("KM cuối", text: kmEnd).keyboardType(.decimalPad)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())

            Text("📏 Tổng KM: \(calculateKmText(start: kmStart.wrappedValue, end: kmEnd.wrappedValue)) km")
                .foregroundColor(.green)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    func saveLog() {
        let log = VehicleLog(
            date: date,
            driverName: driverName,
            equipmentName: equipmentName,
            licensePlate: licensePlate,
            morning: .init(task: morningTask, start: morningStart, end: morningEnd, kmStart: morningKmStart, kmEnd: morningKmEnd),
            afternoon: .init(task: afternoonTask, start: afternoonStart, end: afternoonEnd, kmStart: afternoonKmStart, kmEnd: afternoonKmEnd),
            evening: .init(task: eveningTask, start: eveningStart, end: eveningEnd, kmStart: eveningKmStart, kmEnd: eveningKmEnd)
        )
        logStore.add(log)
        UserDefaults.standard.removeObject(forKey: draftKey)
    }

    func saveDraft() {
        let draft: [String: Any] = [
            "date": formattedDate(date),
            "morningTask": morningTask,
            "morningKmStart": morningKmStart,
            "morningKmEnd": morningKmEnd,
            "afternoonTask": afternoonTask,
            "afternoonKmStart": afternoonKmStart,
            "afternoonKmEnd": afternoonKmEnd,
            "eveningTask": eveningTask,
            "eveningKmStart": eveningKmStart,
            "eveningKmEnd": eveningKmEnd
        ]
        if let data = try? JSONSerialization.data(withJSONObject: draft) {
            UserDefaults.standard.set(data, forKey: draftKey)
        }
    }

    func loadDraftIfToday() {
        let todayKey = formattedDate(date)

        if let existingLog = logStore.logs.first(where: { formattedDate($0.date) == todayKey }) {
            morningTask = existingLog.morning.task
            morningStart = existingLog.morning.start
            morningEnd = existingLog.morning.end
            morningKmStart = existingLog.morning.kmStart
            morningKmEnd = existingLog.morning.kmEnd

            afternoonTask = existingLog.afternoon.task
            afternoonStart = existingLog.afternoon.start
            afternoonEnd = existingLog.afternoon.end
            afternoonKmStart = existingLog.afternoon.kmStart
            afternoonKmEnd = existingLog.afternoon.kmEnd

            eveningTask = existingLog.evening.task
            eveningStart = existingLog.evening.start
            eveningEnd = existingLog.evening.end
            eveningKmStart = existingLog.evening.kmStart
            eveningKmEnd = existingLog.evening.kmEnd
            return
        }

        guard let data = UserDefaults.standard.data(forKey: draftKey),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              json["date"] as? String == todayKey else {
            return
        }

        morningTask = json["morningTask"] as? String ?? ""
        morningKmStart = json["morningKmStart"] as? String ?? ""
        morningKmEnd = json["morningKmEnd"] as? String ?? ""
        afternoonTask = json["afternoonTask"] as? String ?? ""
        afternoonKmStart = json["afternoonKmStart"] as? String ?? ""
        afternoonKmEnd = json["afternoonKmEnd"] as? String ?? ""
        eveningTask = json["eveningTask"] as? String ?? ""
        eveningKmStart = json["eveningKmStart"] as? String ?? ""
        eveningKmEnd = json["eveningKmEnd"] as? String ?? ""
    }
}
