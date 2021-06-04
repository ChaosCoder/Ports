//
//  ProcessView.swift
//  Ports
//
//  Created by Andreas Ganske on 10.05.21.
//

import Foundation
import SwiftUI
import ShellOut

struct ProcessView: View {
    
    var item: Process
    
    @Binding var hovered: Process?
    @Binding var error: IdentifiableError?
    
    static let portFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.hasThousandSeparators = false
        return formatter
    }()
    
    var body: some View {
        HStack(alignment: .top) {
            HStack(alignment: .firstTextBaseline) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(hovered == item ? Color.accentColor : Color.primary)
                + Text(" (\(String(item.pid)))")
                    .foregroundColor(hovered == item ? Color.accentColor : Color.secondary)
                    .font(.monospacedDigit(.body)())
                Button(action: {
                    do {
                        try shellOut(to: "kill", arguments: ["\(item.pid)"])
                    } catch {
                        self.error = IdentifiableError(id: UUID(), error: error)
                    }
                }, label: {
                    if hovered == item {
                        Image(systemName: "xmark.circle.fill")
                    } else {
                        Image(systemName: "xmark.circle.fill")
                            .hidden()
                    }
                })
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                ForEach(item.sockets, id: \.id) { socket in
                    HStack(alignment: .firstTextBaseline) {
                        Text(socket.type.rawValue)
                            .foregroundColor(.gray)
                            .font(.caption)
                            .lineLimit(1)
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            Text("\(socket.address)")
                                .font(.monospacedDigit(.body)())
                                .lineLimit(1)
                            Text(":")
                                .lineLimit(1)
                            Text(String(socket.port))
                                .font(.monospacedDigit(.headline)())
                                .lineLimit(1)
                        }
                    }
                }
            }
            .layoutPriority(1)
        }
        .onHover { isHovered in
            if isHovered {
                hovered = item
            } else if hovered == item {
                hovered = nil
            }
        }
    }
}

struct ProcessView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessView(item: Process(pid: 1, name: "processd", sockets: [Socket(fd: "1u", type: .IPv6, address: "127.0.0.1", port: 46040)]), hovered: .constant(nil), error: .constant(nil))
            .previewLayout(.fixed(width: 300, height: 600))
        ProcessView(item: Process(pid: 1, name: "processd", sockets: [Socket(fd: "1u", type: .IPv4, address: "0.0.0.0", port: 80)]), hovered: .constant(nil), error: .constant(nil))
            .previewLayout(.fixed(width: 300, height: 600))
        ProcessView(item: Process(pid: 1, name: "processd", sockets: [Socket(fd: "1u", type: .IPv4, address: "0.0.0.0", port: 80)]), hovered: .constant(nil), error: .constant(nil))
            .previewLayout(.fixed(width: 300, height: 600))
        ProcessView(item: Process(pid: 1, name: "A process with an Adobe name", sockets: [Socket(fd: "1u", type: .IPv4, address: "0.0.0.0", port: 80)]), hovered: .constant(nil), error: .constant(nil))
            .previewLayout(.fixed(width: 300, height: 600))
    }
}

