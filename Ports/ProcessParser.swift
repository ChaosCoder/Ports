//
//  ProcessParser.swift
//  Ports
//
//  Created by Andreas Ganske on 06.05.21.
//

import Foundation

enum ProcessParserError: Error {
    case empty
    case invalid
}

struct ProcessParser {
    func parse(output: String) throws -> [Process] {
        var processes = [Process]()
        
        var process: PartialProcess?
        var socket: PartialSocket?
        for line in output.components(separatedBy: "\n") {
            guard !line.isEmpty else {
                throw ProcessParserError.empty
            }
            
            let prefix = line[line.startIndex]
            let value = String(line[line.index(after: line.startIndex)...])
            
            switch prefix {
            case "p":
                if let finishedSocket = socket {
                    process?.sockets.append(finishedSocket)
                    socket = nil
                }
                if let parsedProcess = process,
                   let finishedProcess = Process(partial: parsedProcess) {
                    processes.append(finishedProcess)
                    process = nil
                }
                let newProcess = PartialProcess(pid: Int(value))
                process = newProcess
            case "c": process?.name = value
            case "f":
                if let finishedSocket = socket {
                    process?.sockets.append(finishedSocket)
                }
                socket = PartialSocket(fd: value)
            case "n":
                guard let lastColon = value.lastIndex(of: ":") else { break }
                if let port = Int(value[value.index(after: lastColon)...]) {
                    socket?.address = String(value[value.startIndex..<lastColon])
                    socket?.port = port
                }
            case "t":
                switch value {
                case "IPv4": socket?.type = .IPv4
                case "IPv6": socket?.type = .IPv6
                default: break
                }
                
            default: break
            }
        }
        
        if let finishedSocket = socket {
            process?.sockets.append(finishedSocket)
        }
        
        if let parsedProcess = process,
           let finishedProcess = Process(partial: parsedProcess) {
            processes.append(finishedProcess)
        }
        
        return processes
    }
}
