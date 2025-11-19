//
//  GameViewController.swift
//  RockysSuberia
//
//  Created by Breanna Jaigua on 11/17/25.
//

import UIKit
import SpriteKit
import GameplayKit
import SwiftUI

class GameViewController: UIViewController {
    
    var hasShownIntro = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !hasShownIntro {
            hasShownIntro = true
            presentIntroAnimation()
        }
        
     }
    
    func presentIntroAnimation() {
            let intro = AnimationView {
                self.startGame()
            }

            let host = UIHostingController(rootView: intro)
            host.modalPresentationStyle = .fullScreen
            present(host, animated: false)
     }
    
    // startGame() is the same as override func viewDidLoad() but instead it's a function so it doesn't override the introduction animation in the beginning
    // - Andrea A
    func startGame() {
            dismiss(animated: false) { [weak self] in
                guard let self = self else { return }

                if let view = self.view as? SKView {
                    let scene = CollectScene(size: view.bounds.size)
                    scene.scaleMode = .aspectFill
                    view.presentScene(scene)

                    view.ignoresSiblingOrder = true
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
