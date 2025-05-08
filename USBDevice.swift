import Foundation

struct USBDevice: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var vendorId: Int
    var productId: Int
    var serialNr: String?
    var bsdPath: String?
}
