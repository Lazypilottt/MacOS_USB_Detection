// Adi8thMay@0015hrsV1.0.1

import Foundation
import IOKit
import IOKit.usb
import IOKit.serial

protocol USBWatcherDelegate: AnyObject {
    func deviceAdded(_ device: io_object_t)
    func deviceRemoved(_ device: io_object_t)
}

class USBWatcher {
    private var addedIterator: io_iterator_t = 0
    private var removedIterator: io_iterator_t = 0
    private var notificationPort: IONotificationPortRef?
    private weak var delegate: USBWatcherDelegate?

    init(delegate: USBWatcherDelegate) {
        self.delegate = delegate
        registerForUSBNotifications()
    }

    private func registerForUSBNotifications() {
        notificationPort = IONotificationPortCreate(kIOMasterPortDefault)
        guard let port = notificationPort else { return }

        let runLoopSource = IONotificationPortGetRunLoopSource(port).takeUnretainedValue()
        CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, .defaultMode)

        let matchingDict = IOServiceMatching(kIOUSBDeviceClassName)

        IOServiceAddMatchingNotification(port,
                                         kIOFirstMatchNotification,
                                         matchingDict,
                                         { (refcon, iterator) in
                                             let this = Unmanaged<USBWatcher>.fromOpaque(refcon!).takeUnretainedValue()
                                             this.deviceAdded(iterator)
                                         },
                                         UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()),
                                         &addedIterator)

        deviceAdded(addedIterator)

        let removalDict = IOServiceMatching(kIOUSBDeviceClassName)

        IOServiceAddMatchingNotification(port,
                                         kIOTerminatedNotification,
                                         removalDict,
                                         { (refcon, iterator) in
                                             let this = Unmanaged<USBWatcher>.fromOpaque(refcon!).takeUnretainedValue()
                                             this.deviceRemoved(iterator)
                                         },
                                         UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()),
                                         &removedIterator)

        deviceRemoved(removedIterator)
    }

    private func deviceAdded(_ iterator: io_iterator_t) {
        while case let device = IOIteratorNext(iterator), device != 0 {
            delegate?.deviceAdded(device)
            IOObjectRelease(device)
        }
    }

    private func deviceRemoved(_ iterator: io_iterator_t) {
        while case let device = IOIteratorNext(iterator), device != 0 {
            delegate?.deviceRemoved(device)
            IOObjectRelease(device)
        }
    }

    deinit {
        if addedIterator != 0 {
            IOObjectRelease(addedIterator)
        }
        if removedIterator != 0 {
            IOObjectRelease(removedIterator)
        }
        if let port = notificationPort {
            IONotificationPortDestroy(port)
        }
    }
}
