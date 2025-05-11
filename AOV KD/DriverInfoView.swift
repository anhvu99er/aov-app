import SwiftUI

struct DriverInfoView: View {
    @AppStorage("driverName") private var driverName = ""
    @AppStorage("equipmentName") private var equipmentName = ""
    @AppStorage("licensePlate") private var licensePlate = ""

    @State private var isSubmitted = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Thông tin tài xế")) {
                    TextField("Tên tài xế", text: $driverName)
                        .autocapitalization(.allCharacters)
                    TextField("Tên thiết bị", text: $equipmentName)
                        .autocapitalization(.allCharacters)
                    TextField("Biển số xe", text: $licensePlate)
                        .autocapitalization(.allCharacters)
                }

                Button("Xác nhận") {
                    if !driverName.isEmpty && !equipmentName.isEmpty && !licensePlate.isEmpty {
                        isSubmitted = true
                    }
                }
            }
            .navigationTitle("Nhập thông tin ban đầu")
            .navigationBarTitleDisplayMode(.inline)
            .background(
                NavigationLink(
                    destination: NewLogView(),
                    isActive: $isSubmitted
                ) {
                    EmptyView()
                }
                .hidden()
            )
        }
    }
}
