//
//  ThrowScene.swift
//  RockysSuberia
//
//  Created by Breanna Jaigua on 11/19/25.
//

import Foundation
import SpriteKit
class ThrowScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = .blue
        
        let label = SKLabelNode(text: "THROW THE SANDWICH!")
        label.fontSize = 40
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
    }
}
