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
        backgroundColor = .black
        
        setupMouth()
        startRockyMovement()
        setupSub()
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
        sub.size = CGSize(width: 150, height: 60)
        sub.zPosition = 10
        addChild(sub)
    }
    //continous movement of mouth
    func startRockyMovement() {
        let moveRight = SKAction.moveTo(x: size.width - 85, duration: 2.0)
        let moveLeft = SKAction.moveTo(x: 85, duration: 2.0)
        let loop = SKAction.repeatForever(SKAction.sequence([moveRight, moveLeft]))
        
        mouth.run(loop)
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
        } else {
            showMiss()
        }
    }
    func showMiss() {
        let label = SKLabelNode(text: "MISS! Rocky Ate YOU!")
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
    }
    func showSuccess() {
        let label = SKLabelNode(text: "YOU FED ROCKY!")
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 42
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        label.zPosition = 10
        addChild(label)
    }
}
