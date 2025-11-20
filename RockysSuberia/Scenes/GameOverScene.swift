//
//  GameOverScene.swift
//  RockysSuberia
//
//  Created by Breanna Jaigua on 11/20/25.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        let label = SKLabelNode(text: "GAME OVER!")
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 50
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        let tap = SKLabelNode(text: "Tap to retry")
        tap.fontSize = 30
        tap.position = CGPoint(x: size.width/2, y: size.height*0.4)
        addChild(tap)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let newScene = ThrowScene(size: size)
        newScene.scaleMode = scaleMode
        view?.presentScene(newScene, transition: .fade(withDuration: 1))
    }
}
