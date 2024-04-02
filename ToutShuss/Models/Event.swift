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


struct JsonEvent: Decodable {
    var name: String
    var date: Date
    var activity: String
    var pricing: String
    
    func getEvent() -> Event{
        var eventActivity: Activity
        var eventPricing: Pricing
        
        switch self.activity {
        case "ski":
            eventActivity = Activity.ski
                case "cycle":
            eventActivity = Activity.cycle
                case "competition":
            eventActivity = Activity.competition
                case "snowboard":
            eventActivity = Activity.snowboard
                case "party":
            eventActivity = Activity.party
                default:
            eventActivity = Activity.party
        }
        
        switch pricing {
            case "free":
                eventPricing = Pricing.free
            case "paid":
                eventPricing = Pricing.paid
            case "reservation":
                eventPricing = Pricing.reservation
            case "full":
                eventPricing = Pricing.full
            default:
                eventPricing = Pricing.free
        }
        
        return Event(name: self.name, date: self.date, activity: eventActivity, pricing: eventPricing)
    }
    
    init(name: String, date: Date, activity: String, pricing: String) {
        self.name = name
        self.date = date
        self.activity = activity
        self.pricing = pricing
        
        print(activity)

    }
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
