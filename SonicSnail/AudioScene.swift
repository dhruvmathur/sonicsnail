//
//  AudioScene.swift
//  SonicSnail
//
//  Created by Dhruv Mathur on 2022-07-12.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    var audioNode: SKAudioNode!
    
    func setupAudioNode() {
        let musicURL = Bundle.main.url(forResource: "track55", withExtension: "mp3")
        audioNode = SKAudioNode(url: musicURL!)
        // audioNodes.append(audioNode)

        audioNode.isPositional = true
        audioNode.position = CGPoint(x: 0, y: 0)
        
        addChild(audioNode)

        let moveForward = SKAction.moveTo(x: 10000, duration: 2)
//        let moveForward2 = SKAction.moveTo(y: 10000, duration: 1)
        let moveBack = SKAction.moveTo(x: -10000, duration: 2)
//        let moveBack2 = SKAction.moveTo(y: -10000, duration: 1)
        let sequence = SKAction.sequence([moveForward, moveBack])
        let repeatForever = SKAction.repeatForever(sequence)
        
        print("running audionode")

        audioNode.run(repeatForever)
    }

}
