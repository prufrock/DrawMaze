//
// Created by David Kanenwisher on 11/2/22.
//

import Foundation

class AppCoreController {
    var appCore: AppCore?
    private var serviceList: [String] = []
    // This is a bit ugly but going to use it for now.
    // Need to make sure to nil it when done.
    var workItem: DispatchWorkItem? = nil

    let filename: URL

    var serviceCount: Int {
        get { serviceList.count }
    }

    init() {
        // find a better home for this
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        filename = paths[0].appendingPathComponent("AppCore.txt")
    }

    func addService(_ element: String) {
        serviceList.append(element)
        print("loaded service \(element)")
    }

    func hasService(_ element: String) -> Bool {
        serviceList.contains { item in  item == element }
    }

    func save() {
        try! "Terminated".write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        print("wrote to \(filename)")
    }

    func restore() -> Bool {
        let manager = FileManager()
        return manager.fileExists(atPath: filename.path)
    }
}

