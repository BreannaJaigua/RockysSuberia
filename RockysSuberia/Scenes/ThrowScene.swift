//
//  ThrowScene.swift
//  RockysSuberia
//
//  Created by Breanna Jaigua on 11/19/25.
//

import Foundation
import SpriteKit

class ThrowScene: SKScene {
    
    var rocky: SKSpriteNode!
    var mouth: SKSpriteNode!
    var sub: SKSpriteNode!
    var touchStartPoint: CGPoint?
    
    override func didMove(to view: SKView) {
        addBackground()
        setupMouth()
        startRockyMovement()
        setupSub()
        startHazards()
    }
    func setupMouth() {
        mouth = SKSpriteNode(imageNamed: "mouthOpen")
        mouth.position = CGPoint(x: size.width/2, y: size.height * 0.80)
        mouth.size = CGSize(width: 150, height: 150)
        mouth.zPosition = 10
        addChild(mouth)
    }
    func setupSub() {
        sub = SKSpriteNode(imageNamed: "sub")
        sub.position = CGPoint(x: size.width/2, y: 100)
        mouth.size = CGSize(width: 500, height: 500)
        sub.zPosition = 10
        addChild(sub)
    }
    //continous movement of mouth
    func startRockyMovement() {
        let moveRight = SKAction.moveTo(x: size.width - 85, duration: 1.0)
        let moveLeft = SKAction.moveTo(x: 85, duration: 1.0)
        let loop = SKAction.repeatForever(SKAction.sequence([moveRight, moveLeft]))
        
        mouth.run(loop)
    }
    func addBackground() {
        let bg = SKSpriteNode(imageNamed: "uOfR")
        bg.position = CGPoint(x: frame.midX, y: frame.midY)
        bg.zPosition = -10
            addChild(bg)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchStartPoint = touch.location(in: self)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              let start = touchStartPoint else { return }

        let end = touch.location(in: self)
        let dx = start.x - end.x
        let dy = start.y - end.y

        throwSub(dx: dx, dy: dy)
    }
    func throwSub(dx: CGFloat, dy: CGFloat) {

        // convert “drag distance” into velocity
        let velocityX = dx * 1.2
        let velocityY = dy * 1.8

        // animate arc using SKAction
        let throwMotion = SKAction.moveBy(
            x: -velocityX,
            y: -velocityY,
            duration: 0.8
        )

        let curve = SKAction.sequence([
            throwMotion,
            SKAction.fadeOut(withDuration: 0.2)
        ])

        sub.run(curve) {
            self.checkHit()
        }
    }
    func checkHit() {
        if sub.frame.intersects(mouth.frame.insetBy(dx: -50, dy: -20)) {
            showSuccess()
        }
    }
    func showMiss() {
        let label = SKLabelNode(text: "MISS! Rocky will EAT YOU!")
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 40
        label.fontColor = .red
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        label.zPosition = 10
        addChild(label)
        
        // little shake effect
        let shake = SKAction.sequence([
            .moveBy(x: 10, y: 0, duration: 0.05),
            .moveBy(x: -20, y: 0, duration: 0.05),
            .moveBy(x: 10, y: 0, duration: 0.05)
        ])
        label.run(shake)
        
        goToGameOver()
    }
    func showSuccess() {
        let label = SKLabelNode(text: "YOU FED ROCKY!")
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 42
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        label.zPosition = 10
        addChild(label)
    }
    func startHazards() {
        let spawnAction = SKAction.repeatForever(
            SKAction.sequence([
            SKAction.run { self.spawnHazard() },
            SKAction.wait(forDuration: 2.0)
            ])
        )
        run(spawnAction, withKey: "hazardSpawner")
    }
    func spawnHazard() {//broke my head
        let hazardType = Bool.random() ? "bomb" : "hornet"
        let hazard = SKSpriteNode(imageNamed: hazardType)
        
        hazard.name = "hazard"
        hazard.zPosition = 12
        hazard.position = CGPoint(
            x: CGFloat.random(in: 80...(size.width - 80)),
            y: size.height + 50
        )
        
        // make them smaller
        hazard.setScale(hazardType == "bomb" ? 0.1 : 0.2)
        hazard.setScale(hazardType == "hornet" ? 0.1 : 0.2)

        
        
        addChild(hazard)
        
        // --- SIDE-TO-SIDE ZIG ZAG ---
        let left = SKAction.moveBy(x: -80, y: 0, duration: 0.5)
        let right = SKAction.moveBy(x: 160,  y: 0, duration: 0.5)
        let zigzag = SKAction.repeatForever(SKAction.sequence([left, right, left]))

        // --- FALLING MOTION ---
        let fall = SKAction.moveTo(y: -200, duration: 2.0)
        let remove = SKAction.removeFromParent()
        let fallSeq = SKAction.sequence([fall, remove])

        // run both motions together
        hazard.run(zigzag)
        hazard.run(fallSeq)
    }
    func handleHazardHit(hazard: SKNode) {
        hazard.removeFromParent()
        sub.removeFromParent()
        
        let label = SKLabelNode(text: "💥 YOU BLEW UP!")
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 42
        label.fontColor = .red
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        label.zPosition = 50
        addChild(label)
        goToGameOver()
    }
    func checkHazardCollisions() {
        for node in children {
            guard node.name == "hazard" else { continue }

            // if sub hits a bomb / hornet
            if sub.frame.intersects(node.frame) {
                handleHazardHit(hazard: node)
            }

            // if hazard hits mouth
            if mouth.frame.intersects(node.frame) {
                handleRockyHit(hazard: node)
            }
        }
    }
    func handleRockyHit(hazard: SKNode) {
        hazard.removeFromParent()
                
        let shake = SKAction.sequence([
            .moveBy(x: 30, y: 0, duration: 0.05),
            .moveBy(x: -60, y: 0, duration: 0.05),
            .moveBy(x: 30, y: 0, duration: 0.05)
        ])
        mouth.run(shake)
    }
    func goToGameOver() {
        let scene = GameOverScene(size: size)
        scene.scaleMode = scaleMode
        self.view?.presentScene(scene, transition: .fade(withDuration: 1.0))
    }
    override func update(_ currentTime: TimeInterval) {
        checkHazardCollisions()
    }
}
