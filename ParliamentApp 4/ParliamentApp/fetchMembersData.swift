//
//  fetchMemberData.swift
//  ParliamentApp
//
//  Created by Veikko Pelkonen on 4.11.2024.
//

import Foundation

func fetchMembersData(completion: @escaping ([MemberDetails]) -> Void) {
    guard let url = URL(string: "https://users.metropolia.fi/~peterh/mps.json") else {
        print("Invalid URL")
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error fetching data: \(error)")
            completion([])
            return
        }
        
        guard let data = data else {
            print("No data returned")
            completion([])
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let members = try decoder.decode([MemberDetails].self, from: data)
            DispatchQueue.main.async {
                completion(members)
            }
        } catch {
            print("Error decoding JSON: \(error)")
            completion([])
        }
    }.resume()
}
