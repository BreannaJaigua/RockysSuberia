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
    
    var hasShownMenu = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !hasShownMenu {
            hasShownMenu = true
            showMenu()
        }
        
     }
    func showMenu() {
        let menu = StartMenuView { [weak self] in
            self?.dismiss(animated: false) {
                self?.presentIntroAnimation()
            }
        }
        
        let host = UIHostingController(rootView: menu)
        host.modalPresentationStyle = .fullScreen
        present(host, animated: false)
    }
    
    func presentIntroAnimation() {
        let intro = AnimationView {
                    self.dismiss(animated: false) {
                        self.startGame()
                    }
                }
        let host = UIHostingController(rootView: intro)
        host.modalPresentationStyle = .fullScreen
        present(host, animated: false)
     }
    
    // startGame() is the same as override func viewDidLoad() but instead it's a function so it doesn't override the introduction animation in the beginning
    // - Andrea A
    func startGame() {
        if let view = self.view as? SKView {
            let scene = CollectScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
        }
    }
    
    func returnToMenu() {
        self.dismiss(animated: false) {
            self.showMenu()
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
