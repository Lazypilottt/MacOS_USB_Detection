//
//  USBWatcherViewModel.swift
//  USB_DETECTION_APP_V1
//
//  Created by FinTeQ IIT Bhilai on 07/05/25.
//

import Foundation
import IOKit
import IOKit.usb
import IOKit.serial
import Combine

class USBWatcherViewModel: ObservableObject, USBWatcherDelegate {
    @Published var connectedDevices: [USBDevice] = []
    private var usbWatcher: USBWatcher!

    init() {
        usbWatcher = USBWatcher(delegate: self)
    }

    func deviceAdded(_ device: io_object_t) {
        print("Device added: \(device.name() ?? "<unknown>")")
        if let usbDevice = device.getInfo() {
            DispatchQueue.main.async {
                self.connectedDevices.append(usbDevice)
            }
        }
    }

    func deviceRemoved(_ device: io_object_t) {
        print("Device removed: \(device.name() ?? "<unknown>")")
        if let usbDevice = device.getInfo() {
            DispatchQueue.main.async {
                self.connectedDevices.removeAll { $0.id == usbDevice.id }
            }
        }
    }
}
