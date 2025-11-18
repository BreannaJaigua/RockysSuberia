//
//  CollectGameScene.swift
//  RockysSuberia
//
//  Created by Breanna Jaigua on 11/18/25.
//

import Foundation
import SpriteKit

class CollectScene: SKScene, SKPhysicsContactDelegate {
    var basket: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var score = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        setupBasket()
        setupScoreLabel()
        startSpawning()
    }
    func setupBasket() {
        basket = SKSpriteNode(imageNamed: "basket")
        basket.position = CGPoint(x: 50, y: 80)
        basket.zPosition = 3
        addChild(basket)
    }
    func setupScoreLabel() {
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.fontSize = 40
        scoreLabel.position = CGPoint(x: 50, y: size.height - 50)
        addChild(scoreLabel)
    }
    func startSpawning() {
        run(.repeatForever(.sequence([
            .run { self.spawnIngredients() },
                .wait(forDuration: 1.0),
        ])))
    }
    func spawnIngredients() {
        let ingredients = GameRules.randomIngredients()
        
        let node = SKSpriteNode(imageNamed: ingredients.imageName)
        node.name = ingredients.name
        
        node.position = CGPoint(
            x: CGFloat.random(in: 40...(size.width - 40)),
            y: size.height + 50
        )
        let fall = SKAction.moveTo(y: -100, duration: 3.0)
        let remove = SKAction.removeFromParent()
        node.run(.sequence([fall, remove]))
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        <#code#>
    }
    override func update(_ currentTime: TimeInterval) {
        
    }
    
}
