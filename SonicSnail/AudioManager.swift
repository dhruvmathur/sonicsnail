//
//  AudioManager.swift
//  SonicSnail
//
//  Created by Dhruv Mathur on 2022-07-09.
//

import Foundation
import SpriteKit

class AudioManager {
    
    var audioNodes: [SKAudioNode] = []
    
    func setupAudioNode() {
        let musicURL = Bundle.main.url(forResource: "music", withExtension: "mp3")
        let audioNode = SKAudioNode(url: musicURL!)
        audioNodes.append(audioNode)

        audioNode.isPositional = true
        audioNode.position = CGPoint(x: 0, y: 0)

        let moveForward = SKAction.moveTo(y: 1024, duration: 2)
        let moveBack = SKAction.moveTo(y: -1024, duration: 2)
        let sequence = SKAction.sequence([moveForward, moveBack])
        let repeatForever = SKAction.repeatForever(sequence)

        audioNode.run(repeatForever)
    }
    
    func changeAudioNodePositionTo(x: Int, y: Int) {
        
    }
}
