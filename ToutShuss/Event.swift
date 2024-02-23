//
//  Event.swift
//  ToutShuss
//
//  Created by Maxandre Neveux on 22/02/2024.
//

import SwiftUI

struct Event: Identifiable, Hashable, Decodable, Encodable {
    var id: UUID = UUID()
    var name: String
    var date: Date
    var activity: Activity
    var pricing: Pricing
}

enum Activity: String, CaseIterable, Hashable, Decodable, Encodable  {
    case ski = "figure.skiing.downhill"
    case cycle = "figure.outdoor.cycle"
    case competition = "trophy.fill"
    case snowboard = "figure.snowboarding"
    case party = "triangle.fill"
}

enum Pricing: String, CaseIterable, Hashable, Decodable, Encodable  {
    case free, paid, reservation, full

    var color: Color {
        switch self {
        case .free:
            return .green
        case .paid:
            return .blue
        case .reservation:
            return .orange
        case .full:
            return .red
        }
    }
}
