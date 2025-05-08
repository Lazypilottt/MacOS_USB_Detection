import Foundation
import IOKit

extension io_object_t {
    func name() -> String? {
        var serviceName = [CChar](repeating: 0, count: 128)
        let result = IORegistryEntryGetName(self, &serviceName)
        if result == KERN_SUCCESS {
            return String(cString: serviceName)
        }
        return nil
    }

    func getInfo() -> USBDevice? {
        var serviceDictionary: Unmanaged<CFMutableDictionary>?
        let result = IORegistryEntryCreateCFProperties(self, &serviceDictionary, kCFAllocatorDefault, 0)

        guard result == KERN_SUCCESS, let dict = serviceDictionary?.takeRetainedValue() as NSDictionary? else {
            return nil
        }

        let name = dict["USB Product Name"] as? String ?? "Unknown"
        let vendorId = dict["idVendor"] as? Int ?? 0
        let productId = dict["idProduct"] as? Int ?? 0
        let serial = dict["USB Serial Number"] as? String
        let bsdPath = dict["IOCalloutDevice"] as? String

        return USBDevice(name: name, vendorId: vendorId, productId: productId, serialNr: serial, bsdPath: bsdPath)
    }
}
