//
//  PartialModels.swift
//  Ports
//
//  Created by Andreas Ganske on 06.05.21.
//

import Foundation

struct PartialProcess {
    var pid: Int?
    var name: String?
    var sockets: [PartialSocket] = []
}

struct PartialSocket {
    var fd: String?
    var type: SocketType?
    var address: String?
    var port: Int?
}

extension Socket {
    init?(partial: PartialSocket) {
        guard let fd = partial.fd,
              let type = partial.type,
              let address = partial.address,
              let port = partial.port else {
            return nil
        }
        self.fd = fd
        self.type = type
        self.address = address
        self.port = port
    }
}

extension Process {
    init?(partial: PartialProcess) {
        guard let pid = partial.pid,
              let name = partial.name else {
            return nil
        }
        self.pid = pid
        self.name = name
        self.sockets = partial.sockets.compactMap(Socket.init(partial:))
    }
}
