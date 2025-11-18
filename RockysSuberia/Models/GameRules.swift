//
//  GameRules.swift
//  RockysSuberia
//
//  Created by Breanna Jaigua on 11/18/25.
//

// this model layer knows this is lettuce its -10 points
import Foundation

class GameRules {
    static var wantedIngredient = "tomato"
    
    static func randomIngredients() -> Ingredient {
        let wanted = Ingredient(name: "tomato", imageName: "tomato", pointValue: 10, isWanted: true)

        let wrongOnes = [
            Ingredient(name: "fish", imageName: "fish", pointValue: -10, isWanted: false)
        ]
        let bomb = Ingredient(name: "bomb", imageName:"bomb", pointValue: -20, isWanted: false)
        
        let pool = [wanted] + wrongOnes + [bomb]
        
        return pool.randomElement() ?? wanted
    }
}
