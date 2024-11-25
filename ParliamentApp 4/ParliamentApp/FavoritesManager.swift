//
//  FavoritesManager.swift
//  ParliamentApp
//
//  Created by Veikko Pelkonen on 4.11.2024.
//

import SwiftUI

class FavoritesManager: ObservableObject {
    @Published var favoriteMembers: Set<Int> = []

    func toggleFavorite(personNumber: Int) {
        if favoriteMembers.contains(personNumber) {
            favoriteMembers.remove(personNumber)
        } else {
            favoriteMembers.insert(personNumber)
        }
    }
}


