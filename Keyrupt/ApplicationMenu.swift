//
//  ApplicationMenu.swift
//  Keyrupt
//
//  Created by ploouf on 2022-10-16.
//

import Foundation
import SwiftUI

class ApplicationMenu {
    func createMenu() -> NSMenu {
        let menu = NSMenu()

        // Create switch button
        let switchButton = NSSwitch(
            frame: NSRect(x: 0, y: 0, width: 100, height: 20)
        )
        switchButton.state = .off
        switchButton.target = self
        switchButton.action = #selector(toggleKeyboardInput(_:))

        // Create label for switch button
        let label = NSTextField(
            frame: NSRect(x: 0, y: 0, width: 200, height: 20)
        )
        label.stringValue = "Keyrupt"
        label.isEditable = false
        label.isSelectable = false
        label.isBezeled = false
        label.drawsBackground = false
        label.font = NSFont.systemFont(ofSize: 13)

        // Add switch button and label to menu
        let switchMenuItem = NSMenuItem()
        let customView = NSView(frame: NSRect(x: 0, y: 0, width: 200, height: 20))
        customView.addSubview(switchButton)
        customView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 15),
            switchButton.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
            switchButton.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -10),
        ])
        switchMenuItem.view = customView
        menu.addItem(switchMenuItem)

        menu.addItem(NSMenuItem.separator())

        // Add quit item
        let quitItem = NSMenuItem(
            title: "Quit Keyrupt",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        )
        menu.addItem(quitItem)

        return menu
    }

    @objc func toggleKeyboardInput(_ sender: NSSwitch) {
        AppDelegate.instance.isKeyboardEnabled.toggle()
        sender.state = AppDelegate.instance.isKeyboardEnabled ? .on : .off

        if !AppDelegate.instance.isKeyboardEnabled {
            // disable keyboard input
            AppDelegate.instance.removeEventTap()
        } else {
            // enable keyboard input
            AppDelegate.instance.createEventTap()
        }
    }
}

