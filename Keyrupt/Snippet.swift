//
//  Snippet.swift
//  Keyrupt
//
//  Created by ploouf on 2022-10-16.
//

import Foundation

struct Snippet {
    let trigger: String
    let content: String
    
    func matches(_ string: String) -> Bool {
        let hasSuffix = string.hasSuffix(trigger)
        print("Trigger: ", trigger)
        let isBoundary = (string.dropLast(trigger.count).last ?? " " ).isWhitespace
        
        return hasSuffix && isBoundary
    }
}

extension Snippet {
    static var examples: [Snippet] = [
        Snippet(trigger: "xsnippet", content: "Snippet(trigger: \"<#trigger#>\", content: \"<#content#>\"),"),
        Snippet(trigger: "xname", content: "ploouf"),
        Snippet(trigger: "xsite", content: "https://plouuf.github.io/portfolio/"),
        Snippet(trigger: "xgpt", content: "https://chat.openai.com"),
        Snippet(trigger: "xtube", content: "https://www.youtube.com/"),
    ]
}


