import Foundation

struct VehicleLog: Identifiable, Codable {
    var id = UUID()
    let date: Date
    let driverName: String
    let equipmentName: String
    let licensePlate: String

    struct Session: Codable {
        var task: String
        var start: Date
        var end: Date
        var kmStart: String
        var kmEnd: String
    }

    var morning: Session
    var afternoon: Session
    var evening: Session
}
