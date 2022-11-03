//
// Created by David Kanenwisher on 11/2/22.
//

import Foundation

class AppCoreController {
    var appCore: AppCore?
    private var serviceList: [String] = []

    let filename: URL

    init() {
        // find a better home for this
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        filename = paths[0].appendingPathComponent("AppCore.txt")
    }

    func addService(_ element: String) {
        serviceList.append(element)
        print("loaded service \(element)")
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

