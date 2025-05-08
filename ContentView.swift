//
//  ContentView.swift
//  USB_DETECTION_APP_V1
//
//  Created by FinTeQ IIT Bhilai on 07/05/25.
//
// a simple UI for the connected USB devices.
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = USBWatcherViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.connectedDevices, id: \.id) { device in
                VStack(alignment: .leading) {
                    Text("Name: \(device.name)")
                    Text("Vendor ID: \(device.vendorId), Product ID: \(device.productId)")
                    if let path = device.bsdPath {
                        Text("BSD Path: \(path)")
                    }
                    if let serial = device.serialNr {
                        Text("Serial: \(serial)")
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Connected USB Devices")
        }
    }
}
