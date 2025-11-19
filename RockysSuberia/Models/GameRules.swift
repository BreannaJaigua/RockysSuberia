//
//  GameRules.swift
//  RockysSuberia
//
//  Created by Breanna Jaigua on 11/18/25.
//

// this model layer knows this is lettuce its -10 points
import Foundation


class GameRules {
    static var wantedIngredient = Ingredient(
        name: "tomato", imageName: "tomato", pointValue: 10, isWanted: true
    )
    static let allIngredients: [Ingredient] = [
        Ingredient(name: "tomato", imageName: "tomato", pointValue: 10, isWanted: true),
        Ingredient(name: "cheese", imageName: "cheese", pointValue: 10, isWanted: true),
        Ingredient(name: "lettuce", imageName: "lettuce", pointValue: 10, isWanted: true),
        Ingredient(name: "hornet", imageName: "hornet", pointValue: -10, isWanted: false),
        Ingredient(name: "bomb", imageName: "bomb", pointValue: -20, isWanted: false)
    ]
    static func randomIngredient() -> Ingredient {
        return allIngredients.randomElement( ) ?? wantedIngredient
    }
}
