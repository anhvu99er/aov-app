import SwiftUI

struct ContentView: View {
    @AppStorage("driverName") private var driverName = ""
    @AppStorage("equipmentName") private var equipmentName = ""
    @AppStorage("licensePlate") private var licensePlate = ""

    var body: some View {
        if driverName.isEmpty || equipmentName.isEmpty || licensePlate.isEmpty {
            DriverInfoView() // Lần đầu
        } else {
            MainTabView() // Đã nhập rồi → hiện tab
        }
    }
}
