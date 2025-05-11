import SwiftUI

struct MainTabView: View {
    @AppStorage("driverName") private var driverName = ""
    @AppStorage("equipmentName") private var equipmentName = ""
    @AppStorage("licensePlate") private var licensePlate = ""

    var body: some View {
        TabView {
            NewLogView()
                .tabItem {
                    Label("Ghi nhật trình", systemImage: "pencil.and.outline")
                }
               

            LogListView()
                .tabItem {
                    Label("Thông tin", systemImage: "doc.plaintext")
                }

            DriverInfoView()
                .tabItem {
                    Label("Tài xế", systemImage: "person.circle")
                    VStack(alignment: .leading, spacing: 2) {
                        if !driverName.isEmpty {
                            Text("👤 \(driverName)")
                                .font(.caption2)
                        }
                        if !equipmentName.isEmpty || !licensePlate.isEmpty {
                            Text("🚜 \(equipmentName) - \(licensePlate)")
                                .font(.caption2)
                        }
                    }
                }
        }
    }
}
