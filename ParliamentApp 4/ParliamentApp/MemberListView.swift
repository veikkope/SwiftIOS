import SwiftUI
import SwiftData

struct MemberListView: View {
    @State private var members: [MemberDetails] = []
    @State private var favorites: Set<Int> = [] // Favorite member IDs
    @State private var favoriteParties: Set<String> = [] // Favorite parties
    @State private var showFavoritesOnly: Bool = false // Toggle to show only favorites
    @State private var showingPreferences: Bool = false // Toggle to show preferences UI
    @State private var selectedParty: String? = nil

    // Group members by party
    private var groupedMembers: [String: [MemberDetails]] {
        Dictionary(grouping: members, by: { $0.party })
    }
    
    // List of unique party names
    private var partyNames: [String] {
        groupedMembers.keys.sorted()
    }
    
    // Filtered members based on favorites and selected preferences
    private var filteredMembers: [MemberDetails] {
        if let selectedParty = selectedParty {
            return groupedMembers[selectedParty] ?? []
        } else if showFavoritesOnly {
            return members.filter { favorites.contains($0.id) || favoriteParties.contains($0.party) }
        } else {
            return members
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Horizontal Scroll View for Party Selection
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        // "All" Button to reset filter
                        Button(action: {
                            selectedParty = nil
                            showFavoritesOnly = false
                        }) {
                            Text("All")
                                .padding()
                                .background(selectedParty == nil && !showFavoritesOnly ? Color.blue : Color.gray.opacity(0.2))
                                .foregroundColor(selectedParty == nil && !showFavoritesOnly ? .white : .primary)
                                .cornerRadius(10)
                        }
                        
                        // Buttons for each party
                        ForEach(partyNames, id: \.self) { party in
                            Button(action: {
                                selectedParty = party
                                showFavoritesOnly = false
                            }) {
                                Text(party)
                                    .padding()
                                    .background(selectedParty == party ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundColor(selectedParty == party ? .white : .primary)
                                    .cornerRadius(10)
                            }
                        }

                        // "Favorites" Button to show only favorites
                        Button(action: {
                            showFavoritesOnly = true
                            selectedParty = nil
                        }) {
                            Text("Favorites")
                                .padding()
                                .background(showFavoritesOnly ? Color.blue : Color.gray.opacity(0.2))
                                .foregroundColor(showFavoritesOnly ? .white : .primary)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }

                // Member List filtered by selected preferences
                List(filteredMembers) { member in
                    NavigationLink(destination: MemberDetailView(member: member, isFavorite: favorites.contains(member.id)) { isFavorite in
                        if isFavorite {
                            favorites.insert(member.id)
                        } else {
                            favorites.remove(member.id)
                        }
                    }) {
                        HStack {
                            AsyncImage(url: URL(string: "https://users.metropolia.fi/~peterh/\(member.picture)")) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } placeholder: {
                                PartyImage(party: member.party)
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            }

                            VStack(alignment: .leading) {
                                Text("\(member.first) \(member.last)")
                                    .font(.headline)
                                Text(member.party.uppercased())
                                    .font(.subheadline)
                            }
                            .padding(.leading, 10)
                        }
                    }
                }
                .navigationTitle("Members of Parliament")
                .toolbar {
                    Button(action: {
                        showingPreferences = true
                    }) {
                        Image(systemName: "gear")
                    }
                }
                .onAppear {
                    members = loadMembersData()
                }
                .sheet(isPresented: $showingPreferences) {
                    PreferencesView(members: members, favorites: $favorites, favoriteParties: $favoriteParties)
                }
            }
        }
    }
}

struct PreferencesView: View {
    var members: [MemberDetails]
    @Binding var favorites: Set<Int>
    @Binding var favoriteParties: Set<String>

    // Group members by party
    private var groupedMembers: [String: [MemberDetails]] {
        Dictionary(grouping: members, by: { $0.party })
    }
    
    // Use dismiss environment variable
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Favorite Parties")) {
                    ForEach(groupedMembers.keys.sorted(), id: \.self) { party in
                        Toggle(isOn: Binding(
                            get: { favoriteParties.contains(party) },
                            set: { isFavorite in
                                if isFavorite {
                                    favoriteParties.insert(party)
                                } else {
                                    favoriteParties.remove(party)
                                }
                            }
                        )) {
                            Text(party)
                        }
                    }
                }

                Section(header: Text("Favorite Members")) {
                    ForEach(members) { member in
                        Toggle(isOn: Binding(
                            get: { favorites.contains(member.id) },
                            set: { isFavorite in
                                if isFavorite {
                                    favorites.insert(member.id)
                                } else {
                                    favorites.remove(member.id)
                                }
                            }
                        )) {
                            Text("\(member.first) \(member.last) (\(member.party))")
                        }
                    }
                }
            }
            .navigationTitle("Preferences")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss() // Dismiss the sheet using SwiftUI's dismiss action
                    }
                }
            }
        }
    }
}

