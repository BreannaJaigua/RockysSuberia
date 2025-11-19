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
    var orderLabel: SKLabelNode!
    var score = 0
    
    var collectedCounts: [String: Int] = [:]
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        //new random order
        GameRules.generateRandomOrder()
        
        setupBasket()
        setupScoreLabel()
        setupOrderLabel()
        startSpawning()
    }
    func setupBasket() {
        basket = SKSpriteNode(imageNamed: "basket")
        basket.size = CGSize(width: 150, height: 150)
        basket.position = CGPoint(x: 50, y: 80)
        basket.zPosition = 3
        addChild(basket)
    }
    func setupScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.fontSize = 40
        scoreLabel.position = CGPoint(x: 100, y: size.height - 200)
        scoreLabel.text = "Score: 0"
        scoreLabel.zPosition = 3
        addChild(scoreLabel)
    }
    func setupOrderLabel()  {
        orderLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        orderLabel.fontSize = 24
        orderLabel.fontColor = .white
        orderLabel.position = CGPoint(x: size.width/2, y: size.height - 50)
        orderLabel.zPosition = 3
        
        let text = GameRules.currentOrder.required
            .map { "\($0.key): \($0.value)" }
            .joined(separator: ", ")
        orderLabel.text = "Collect: \(text)"
        orderLabel.position = CGPoint(x: size.width/2, y: size.height - 50)

        addChild(orderLabel)
    }
    func startSpawning() {
        run(.repeatForever(.sequence([
            .run { self.spawnIngredients() },
                .wait(forDuration: 1.0),
        ])))
    }
    func spawnIngredients() {
        let ingredients = GameRules.randomIngredient()
        
        let node = SKSpriteNode(imageNamed: ingredients.imageName)
        node.name = ingredients.name
        node.size = CGSize(width: 60, height: 60)
        node.userData = ["points": ingredients.pointValue]
        
        node.position = CGPoint(
            x: CGFloat.random(in: 40...(size.width - 40)),
            y: size.height + 50
        )
        addChild(node)
        
        let fall = SKAction.moveTo(y: -100, duration: 3.0)
        let remove = SKAction.removeFromParent()
        node.run(.sequence([fall, remove]))
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            basket.position.x = touch.location(in:self).x
        }
    }
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            guard node != basket && node != scoreLabel else { continue }
            guard node.name != nil else { continue }
            
            if basket.frame.intersects(node.frame) {
                if let points = node.userData?["points"] as? Int {
                    score += points
                    scoreLabel.text = "Score: \(score)"
                }
                node.removeFromParent()
            }
        }
    }
    func checkIfOrderComplete() {
        for(ingredient, neededAmount) in GameRules.currentOrder.required {
            let collected = collectedCounts[ingredient, default:0 ]
            if collected < neededAmount {
                return
            }
        }
      //  goToThrowScene()
    }
}

