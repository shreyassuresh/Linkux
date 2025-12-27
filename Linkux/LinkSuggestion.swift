//
//  LinkSuggestion.swift
//  Linkux
//
//  Created by Teacher on 27/12/25.
//

import Foundation

struct LinkSuggestion: Identifiable {
    let id = UUID()
    let note: Note
    let strength: Double
}

