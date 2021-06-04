//
//  ProcessManager.swift
//  Ports
//
//  Created by Andreas Ganske on 06.05.21.
//

import Foundation
import SwiftUI
import ShellOut

struct ProcessList {
    var lastUpdated: Date
    var processes: [Process]
}

protocol ProcessManagerType {
    func enablePolling(_ enabled: Bool)
}

class ProcessManager: ProcessManagerType, ObservableObject {

    @Published private(set) var processList: ProcessList
    @Published private(set) var error: IdentifiableError?

    let parser: ProcessParser
    var timer: Timer?

    init(parser: ProcessParser) {
        self.parser = parser
        self.processList = ProcessList(lastUpdated: Date(), processes: [])

        updateProcessList()
    }

    func update() {
        timer?.fire()
    }

    func enablePolling(_ enabled: Bool) {
        timer?.invalidate()
        if enabled {
            updateProcessList()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [unowned self] _ in
                updateProcessList()
            }
        } else {
            timer = nil
        }
    }

    func updateProcessList() {
        do {
            let output = try shellOut(to: "/usr/sbin/lsof", arguments: ["-iTCP", "-sTCP:LISTEN", "-n", "-P", "-F"])
            let processes = try self.parser.parse(output: output)
            self.processList = ProcessList(lastUpdated: Date(), processes: processes)
        } catch {
            self.error = IdentifiableError(error: error)
        }
    }
}
