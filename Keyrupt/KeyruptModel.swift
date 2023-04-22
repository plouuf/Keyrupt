//
//  KeyruptModel.swift
//  Keyrupt
//
//  Created by ploouf on 2022-10-16.
//

import Foundation
import AppKit

extension NSEvent {
    var isDelete: Bool {
        keyCode == 51
    }
}

class KeyruptModel: ObservableObject {
    @Published var text = ""
    @Published var snippets = Snippet.examples
    
    init() {
        
        print("We running...")
        
        
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown, .otherMouseDown]) { _ in
            self.text = ""
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { (event) in
            guard let characters = event.characters else { return }
            print(characters, event.keyCode)
            
            if event.isDelete && !self.text.isEmpty {
                self.text.removeLast()
                
            } else if event.keyCode > 100 {
                self.text = ""
                
            } else if !event.modifierFlags.contains(.command) {

                self.text += characters
            }
            
            self.matchSnippet()
            
        }
    }
    
    func matchSnippet() {
        if let match = snippets.first(where: { $0.matches(self.text)}) {
            insertSnippet(match)
        }
    }
    
    func delete() {
        
        let eventSource = CGEventSource(stateID: .combinedSessionState)
        
        let keyDownEvent = CGEvent(
            keyboardEventSource: eventSource,
            virtualKey: CGKeyCode(51),
            keyDown: true
        )
        
        let keyUpEvent = CGEvent(
            keyboardEventSource: eventSource,
            virtualKey: CGKeyCode(51),
            keyDown: false
        )
        
        keyDownEvent?.post(tap: .cghidEventTap)
        keyUpEvent?.post(tap: .cghidEventTap)
    }
    
    func paste() {
        
        let eventSource = CGEventSource(stateID: .combinedSessionState)
        
        let keyDownEvent = CGEvent(
            keyboardEventSource: eventSource,
            virtualKey: CGKeyCode(9),
            keyDown: true
        )
        
        keyDownEvent?.flags.insert(.maskCommand)
        
        let keyUpEvent = CGEvent(
            keyboardEventSource: eventSource,
            virtualKey: CGKeyCode(9),
            keyDown: false
        )
        
        keyDownEvent?.post(tap: .cghidEventTap)
        keyUpEvent?.post(tap: .cghidEventTap)
    }
    
    func insertSnippet(_ snippet: Snippet) {
        print("Inserting \(snippet)")
        
        //Delete trigger
        for _ in snippet.trigger {
            delete()
        }
        
        //Insert content
        let oldClipboard = NSPasteboard.general.string(forType: .string)
        
        NSPasteboard.general.declareTypes([.string], owner: nil)
        
        NSPasteboard.general.setString(snippet.content, forType: .string)
        
        paste()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let oldClipboard = oldClipboard {
                NSPasteboard.general.setString(oldClipboard, forType: .string)
            }
        }
        
    }
}
