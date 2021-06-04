//
//  StatusBarController.swift
//  Ports
//
//  Created by Andreas Ganske on 05.05.21.
//

import Foundation
import AppKit

class StatusBarController: NSObject, NSPopoverDelegate {

    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var popover: NSPopover

    private var processManager: ProcessManagerType

    init(popover: NSPopover, processManager: ProcessManagerType) {
        self.popover = popover
        self.processManager = processManager

        statusBar = NSStatusBar.system
        statusItem = statusBar.statusItem(withLength: 20.0)

        super.init()

        popover.delegate = self

        if let statusBarButton = statusItem.button {
            statusBarButton.image = NSImage(named: "MenuBarIcon")
            statusBarButton.image?.size = NSSize(width: 18.0, height: 18.0)
            statusBarButton.image?.isTemplate = true
            statusBarButton.setButtonType(.onOff)

            NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown) { [weak self] event in
                if event.window == self?.statusItem.button?.window {
                    self?.togglePopover(sender: statusBarButton)
                    return nil
                }

                return event
            }
        }
    }

    @objc func togglePopover(sender: AnyObject) {
        if popover.isShown {
            hidePopover(sender)
        } else {
            showPopover(sender)
        }
    }

    func showPopover(_ sender: AnyObject) {
        if let statusBarButton = statusItem.button {
            statusBarButton.highlight(true)
            popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
        }
    }

    func hidePopover(_ sender: AnyObject) {
        popover.performClose(sender)
    }

    func popoverWillClose(_ notification: Notification) {
        statusItem.button?.highlight(false)
        processManager.enablePolling(false)
    }

    func popoverWillShow(_ notification: Notification) {
        processManager.enablePolling(true)
    }
}
