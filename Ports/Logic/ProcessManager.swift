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

class ProcessManager: ObservableObject {
    @Published private(set) var processList: ProcessList
    
    let parser: ProcessParser
    var timer: Timer?
    
    init(parser: ProcessParser) {
        self.parser = parser
        let output = try! shellOut(to: "/usr/sbin/lsof", arguments: ["-iTCP", "-sTCP:LISTEN", "-n", "-P", "-F"])
        let processes = try! parser.parse(output: output)
        processList = ProcessList(lastUpdated: Date(), processes: processes)
        
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [unowned self] _ in
            let output = try! shellOut(to: "/usr/sbin/lsof", arguments: ["-iTCP", "-sTCP:LISTEN", "-n", "-P", "-F"])
            let processes = try! self.parser.parse(output: output)
            self.processList = ProcessList(lastUpdated: Date(), processes: processes)
        }
    }
    
    func update() {
        timer?.fire()
    }
}
