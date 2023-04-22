//
//  KeyruptApp.swift
//  Keyrupt
//
//  Created by ploouf on 2022-10-16.
//

import SwiftUI
import CoreGraphics
import ApplicationServices

@main
struct KeyruptApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    static private(set) var instance: AppDelegate!
    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = ApplicationMenu()
    var isKeyboardEnabled = false
    var eventTap: CFMachPort?
    var keyruptModel: KeyruptModel?

    func getPermissions() {
        print("Getting Permissions...")
        AXIsProcessTrustedWithOptions(
            [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true] as CFDictionary
        )
    }

    func createEventTap() {
        let eventMask = (1 << CGEventType.keyDown.rawValue)
        
        let eventTapCallback: CGEventTapCallBack = { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
            guard !AppDelegate.instance.isKeyboardEnabled else {
                return nil
            }
            return Unmanaged.passRetained(event)
        }
        let eventTap = CGEvent.tapCreate(tap: .cghidEventTap,
                                         place: .headInsertEventTap,
                                         options: .defaultTap,
                                         eventsOfInterest: CGEventMask(eventMask),
                                         callback: eventTapCallback,
                                         userInfo: nil)
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap!, enable: true)
        self.eventTap = eventTap
    }

    func removeEventTap() {
        guard let eventTap = self.eventTap else {
            return
        }
        CGEvent.tapEnable(tap: eventTap, enable: false)
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        self.eventTap = nil
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        getPermissions()
        AppDelegate.instance = self
        statusBarItem.button?.image = NSImage(systemSymbolName: "keyboard", accessibilityDescription: "keyboard")
        statusBarItem.button?.imagePosition = .imageLeading
        statusBarItem.menu = menu.createMenu()
        createEventTap()
        keyruptModel = KeyruptModel()
    }

    func applicationWillTerminate(_ notification: Notification) {
        removeEventTap()
    }
}
