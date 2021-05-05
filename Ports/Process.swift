//
//  Process.swift
//  Ports
//
//  Created by Andreas Ganske on 05.05.21.
//

import Foundation

enum SocketType: String {
    case IPv4
    case IPv6
}

struct Socket {
    var fd: String
    var type: SocketType
    var address: String
    var port: Int
}

extension Socket: Identifiable {
    var id: String { fd }
}

struct Process {
    var pid: Int
    var name: String
    var sockets: [Socket]
}

extension Process: Identifiable {
    var id: Int { pid }
}
