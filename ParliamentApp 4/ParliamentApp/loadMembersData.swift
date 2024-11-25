//
//  loadMembersData.swift
//  ParliamentApp
//
//  Created by Veikko Pelkonen on 4.11.2024.
//

import Foundation

func loadMembersData() -> [MemberDetails] {
    guard let url = Bundle.main.url(forResource: "mps", withExtension: "json") else {
        print("Could not find JSON file")
        return []
    }
    
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode([MemberDetails].self, from: data)
    } catch {
        print("Error loading JSON data: \(error)")
        return []
    }
}
