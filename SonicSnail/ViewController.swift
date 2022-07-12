//
//  ViewController.swift
//  SonicSnail
//
//  Created by Dhruv Mathur on 2022-07-08.
//

import UIKit
import SceneKit
import SpriteKit

class ViewController: UIViewController {
    
    var sceneView: SKView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sceneView = SKView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view = sceneView
        
        if let view = self.view as! SKView? {
            print("gamescene")
            let scene = GameScene()
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(scene)
            print("calling setupAudioNode")
            scene.setupAudioNode()
        }
    }
}

