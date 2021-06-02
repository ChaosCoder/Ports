//
//  ContentView.swift
//  Ports
//
//  Created by Andreas Ganske on 05.05.21.
//

import SwiftUI
import ShellOut

struct IdentiableError: Error, Identifiable {
    var id: UUID
    var error: Error
    
    var localizedDescription: String { error.localizedDescription }
}

struct ContentView<ViewModelType: MainViewModelType>: View {
    @ObservedObject var viewModel: ViewModelType
    @State var error: IdentiableError?
    
    var body: some View {
        VStack(alignment: .leading) {
            List(viewModel.processList.processes, id: \.id) { item in
                ProcessView(item: item, hovered: false, error: $error)
                    .onTapGesture {
                        viewModel.update()
                    }
            }
            HStack {
                Spacer()
                MenuButton(
                    label: Image(systemName: "gearshape.fill"),
                    content: {
                        Button(NSLocalizedString("quit", comment: "")) {
                            exit(0)
                        }
                    })
                    .frame(width: 20, height: 20)
                .menuButtonStyle(BorderlessButtonMenuButtonStyle())
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
            }
        }
        .alert(item: $error, content: { error in
            Alert(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("OK")))
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

protocol MainViewModelType: ObservableObject {
    var processList: ProcessList { get }
    var lastUpdateFormatter: DateFormatter { get }
    
    func update()
}

class MainViewModel: ObservableObject, MainViewModelType {
    @ObservedObject var processManager: ProcessManager
    @Published var processList: ProcessList

    init(processManager: ProcessManager) {
        self.processManager = processManager
        self.processList = ProcessList(lastUpdated: Date(), processes: [])
        processManager.$processList.assign(to: &$processList)
    }
    
    var lastUpdateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    func update() {
        self.processManager.update()
    }
}

class PreviewMainViewModel: MainViewModelType {
    var processList: ProcessList = ProcessList(lastUpdated: Date(),
                                               processes: [Process(pid: 1,
                                                                   name: "A longer process name",
                                                                   sockets: [Socket(fd: "1u", type: .IPv4, address: "127.0.0.1", port: 1337),
                                                                             Socket(fd: "1u", type: .IPv6, address: "*", port: 8080)]),
                                                           Process(pid: 2,
                                                                   name: "xcodecd",
                                                                   sockets: [Socket(fd: "2u", type: .IPv4, address: "127.0.0.1", port: 8080)])])
    
    var lastUpdateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    func update() {
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: PreviewMainViewModel())
            .previewLayout(.fixed(width: 300, height: 600))
    }
}
