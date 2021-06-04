//
//  AppDelegate.swift
//  Ports
//
//  Created by Andreas Ganske on 05.05.21.
//

import Cocoa
import SwiftUI
import ShellOut

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBarController: StatusBarController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let parser = ProcessParser()
        let processManager = ProcessManager(parser: parser)

        let viewModel = MainViewModel(processManager: processManager)
        let mainView = MainView(viewModel: viewModel)

        let popover = NSPopover()
        popover.contentSize = NSSize(width: 360, height: 360)
        popover.contentViewController = NSHostingController(rootView: mainView)
        popover.behavior = NSPopover.Behavior.transient

        statusBarController = StatusBarController(popover: popover, processManager: processManager)
    }
}
