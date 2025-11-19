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
    var progressLabel: SKLabelNode!
    
    var collectedCounts: [String: Int] = [:]
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        //new random order
        GameRules.generateRandomOrder()
        
        setupBasket()
        setupScoreLabel()
        setupOrderLabel()
        startSpawning()
        setupProgressLabel()
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
            .joined(separator: "\n")
        orderLabel.text = "Collect: \n\(text)"
        orderLabel.verticalAlignmentMode = .top
        orderLabel.fontSize = 18

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
                let name = node.name!
                //shake
                if name == "bomb" || name == "hornet" {
                    shakeScreen()
                }
                collectedCounts[name, default: 0] += 1
                updateProgressLabel()


                if let points = node.userData?["points"] as? Int {
                    score += points
                    scoreLabel.text = "Score: \(score)"
                }
                node.removeFromParent()
                
                checkIfOrderComplete()
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
        showOrderCompleteText()
        goToThrowScene()
    }
    func goToThrowScene() {
        let nextScene = ThrowScene(size: self.size)
        nextScene.scaleMode = .aspectFill
        
        self.view?.presentScene(
            nextScene,
            transition: SKTransition.fade(withDuration: 1.0)
        )
    }
    func showOrderCompleteText() {
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.text = "ORDER COMPLETE!"
        label.fontSize = 40
        label.fontColor = .yellow
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        label.zPosition = 999
        addChild(label)

        label.run(.sequence([
            .scale(to: 1.2, duration: 0.2),
            .wait(forDuration: 3.0),
            .fadeOut(withDuration: 0.5),
            .run { self.goToThrowScene() }
        ]))
    }
    func setupProgressLabel() {
        progressLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        progressLabel.fontSize = 20
        progressLabel.fontColor = .yellow
        progressLabel.position = CGPoint(x: size.width/2, y: size.height - 200)
        progressLabel.zPosition = 3
        progressLabel.horizontalAlignmentMode = .center
        progressLabel.verticalAlignmentMode = .top

        updateProgressLabel()
        addChild(progressLabel)
    }
    func updateProgressLabel() {
        var lines: [String] = []

        for (ingredient, needed) in GameRules.currentOrder.required {
            let collected = collectedCounts[ingredient, default: 0]
            lines.append("\(ingredient): \(collected)/\(needed)")
        }

        progressLabel.text = lines.joined(separator: "\n")
    }
    func shakeScreen() {
        guard let view = self.view else { return }

        let shake = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shake.timingFunction = CAMediaTimingFunction(name: .linear)
        shake.duration = 0.3
        shake.values = [ -10, 10, -8, 8, -5, 5, 0 ]

        view.layer.add(shake, forKey: "shake")
    }
}

