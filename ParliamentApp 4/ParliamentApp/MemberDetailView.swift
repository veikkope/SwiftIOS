//
//  MemberDetailView.swift
//  ParliamentApp
//
//  Created by Veikko Pelkonen on 4.11.2024.
//

import SwiftUI
import SwiftData

struct MemberDetailView: View {
    var member: MemberDetails
    @State var isFavorite: Bool
    var toggleFavorite: (Bool) -> Void

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://users.metropolia.fi/~peterh/\(member.picture)")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
            } placeholder: {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
            }
            
            Text("\(member.first) \(member.last)")
                .font(.largeTitle)
                .padding()

            
            Text("Party: \(member.party.uppercased())")
                .font(.title2)
                .padding()
            
            PartyImage(party: member.party)

            Text("Constituency: \(member.constituency)")
                .padding()

            Button(action: {
                isFavorite.toggle()
                toggleFavorite(isFavorite)
            }) {
                Text(isFavorite ? "Remove from Favorites" : "Add to Favorites")
                    .foregroundColor(.white)
                    .padding()
                    .background(isFavorite ? Color.red : Color.blue)
                    .cornerRadius(8)
            }
            .padding()
        }
        .navigationTitle("\(member.first) \(member.last)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

