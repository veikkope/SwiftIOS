//
//  Person.swift
//  ParliamentApp
//
//  Created by Veikko Pelkonen on 4.11.2024.
//
import SwiftUI
import SwiftData

struct MemberDetails: Identifiable, Codable {
    var id: Int { personNumber }
    var personNumber: Int
    var seatNumber: Int
    var last: String
    var first: String
    var party: String
    var minister: Bool
    var picture: String
    var twitter: String
    var bornYear: Int
    var constituency: String
    
}



