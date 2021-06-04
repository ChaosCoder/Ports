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

    var popover = NSPopover()
    
    var statusBar: StatusBarController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let parser = ProcessParser()
        let processManager = ProcessManager(parser: parser)
        let viewModel = MainViewModel(processManager: processManager)
        let contentView = MainView(viewModel: viewModel)
        
        // Set the SwiftUI's ContentView to the Popover's ContentViewController
        popover.contentSize = NSSize(width: 360, height: 360)
        popover.contentViewController = NSHostingController(rootView: contentView)
        popover.behavior = NSPopover.Behavior.transient
        
        // Create the Status Bar Item with the above Popover
        statusBar = StatusBarController.init(popover)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

