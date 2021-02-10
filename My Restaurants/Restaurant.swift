//
//  Restaurant.swift
//  My Restaurants
//
//  Created by Gil Jetomo on 2021-02-04.
//

import Foundation
import UIKit

enum Layout: String {
    case grid
    case row
    mutating func toggle() {
        self = self == .grid ? .row : .grid
    }
}
enum Section: Hashable {
    case filter
    case restaurants
}
enum Item: Hashable {
    case filter(Type)
    case restaurant(Restaurant)
}
struct Restaurant: Hashable {
    let identifier = UUID()
    var title: String
    var price: Price
    var image: UIImage?
    var type: [Type]
    static var selectedItems = [Type]()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(title)
        hasher.combine(price)
        hasher.combine(image)
        hasher.combine(type)
    }
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        return lhs.title == rhs.title
    }

    static let restaurants: [Restaurant] = [
        Restaurant(title: "Jollibee", price: .cheap, image: UIImage(named: "jollibee"), type: [.fastfood]),
        Restaurant(title: "Goldilocks", price: .cheap, image: UIImage(named: "goldilocks"), type: [.fastfood, .cakes]),
        Restaurant(title: "Good Taste", price: .cheap, image: UIImage(named: "good taste"), type: [.seafood, .cakes, .lunch]),
        Restaurant(title: "Mary Grace", price: .expensive, image: UIImage(named: "mary grace"), type: [.cakes, .lunch, .breakfast]),
        Restaurant(title: "Barrio Fiesta", price: .expensive, image: UIImage(named: "barrio fiesta"), type: [.lunch]),
        Restaurant(title: "Sambokojin", price: .expensive, image: UIImage(named: "sambokojin"), type: [.buffet, .seafood]),
        Restaurant(title: "Vikings", price: .expensive, image: UIImage(named: "vikings"), type: [.buffet, .seafood]),
        Restaurant(title: "Cabalen", price: .cheap, image: UIImage(named: "cabalen"), type: [.buffet, .lunch]),
        Restaurant(title: "Mesa", price: .expensive, image: UIImage(named: "mesa"), type: [.breakfast, .lunch]),
        Restaurant(title: "Kuya J", price: .expensive, image: UIImage(named: "kuya j"), type: [.lunch]),
        Restaurant(title: "Mang Inasal", price: .cheap, image: UIImage(named: "mang inasal"), type: [.fastfood, .breakfast]),
        Restaurant(title: "Chowking", price: .cheap, image: UIImage(named: "chowking"), type: [.fastfood, .chinese])
    ]
}
enum Price: String {
    case cheap = "$"
    case expensive = "$$"
}
enum Type: String, CaseIterable, Equatable {
    case breakfast, lunch, seafood, fastfood, cakes,
         chinese, buffet
}
