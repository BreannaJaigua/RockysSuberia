//
//  GameRules.swift
//  RockysSuberia
//
//  Created by Breanna Jaigua on 11/18/25.
//

// this model layer knows this is lettuce its -10 points
import Foundation

struct Order {
    var required: [String: Int]   // ingredient -> quantity
}
class GameRules {
    static var currentOrder = Order(required: [:])
    
    static var collectibles = ["tomato", "cheese", "lettuce"]
    static var badCollectibles = ["hornet", "bomb"]
    static let allIngredients: [Ingredient] = [
        Ingredient(name: "tomato", imageName: "tomato", pointValue: 10, isWanted: true),
        Ingredient(name: "cheese", imageName: "cheese", pointValue: 10, isWanted: true),
        Ingredient(name: "lettuce", imageName: "lettuce", pointValue: 10, isWanted: true),
        Ingredient(name: "hornet", imageName: "hornet", pointValue: -10, isWanted: false),
        Ingredient(name: "bomb", imageName: "bomb", pointValue: -20, isWanted: false)
    ]
    static func generateRandomOrder() {
        var newOrder: [String: Int] = [:]
        for ingredient in collectibles {
            let amount = Int.random(in: 1...5)
            newOrder[ingredient] = amount
        }
        currentOrder = Order(required: newOrder)
    }
    static func randomIngredient() -> Ingredient {
        return allIngredients.randomElement()!
    }
}
