//
//  ScoreNode.swift
//  BombBlocksSwift
//
//  Created by JackYeh on 2016/2/24.
//  Copyright © 2016年 MarriageKiller. All rights reserved.
//

import SpriteKit

class ScoreNode: SKShapeNode {
    
    var score : Int = 0
    var buttonLabel : SKLabelNode
    
    /**
     Initializer for Score label
     - Parameter labelRect : Rect of score label
     - Parameter labelPosition : Position of score label
    */
    init(labelRect: CGRect, labelPosition:CGPoint ) {

        buttonLabel = SKLabelNode(fontNamed:"AmericanTypewriter-Bold")
        buttonLabel.text = String(score);
        buttonLabel.fontSize = 90;
        buttonLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Baseline
        buttonLabel.fontColor = UIColor(white: 1, alpha: 0.8)
        
        super.init()
        path = UIBezierPath(rect: labelRect).CGPath
        position = CGPointMake( labelPosition.x, labelPosition.y + 80)
        fillColor = UIColor.clearColor()
        strokeColor = UIColor.clearColor()
        addChild(buttonLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Update game score and runs a score change action
     - Parameter addScore : Score to be added to current score
     */
    func changeScore(addScore:Double) {
        
        let currentScore = score
        let actionDuration :NSTimeInterval = 0.5
        score += Int(addScore)

        let changeScore = SKAction.customActionWithDuration(actionDuration) { (SKNode, CGFloat) -> Void in
            let updateScore = currentScore + Int( addScore * (Double(CGFloat)/actionDuration) )
            self.buttonLabel.text = String(updateScore)
        }
        self.runAction(changeScore)
    }
    
    /**
     Reset game score
    */
    func resetScore() {
        score = 0
        buttonLabel.text = String(score)
    }

}
