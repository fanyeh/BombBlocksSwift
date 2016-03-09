//
//  Block.swift
//  BombBlocksSwift
//
//  Created by JackYeh on 2016/3/1.
//  Copyright © 2016年 MarriageKiller. All rights reserved.
//

import SpriteKit

class Block:SKSpriteNode {
    
    /**
     Define type of block.
     - Normal       : Normal block.
     - Bomb         : Block with bomb.
     - Background   : Background Block.
     - Next         : Hint for incoming block.
     */
    enum MainType :Int {
        case Normal = 0 , Bomb = 1, Background = 2, Next = 3
    }
    
    /**
     Define base color of block.
     - Blue
     - Red
     - Yellow
     - Green
     - Black
     - AlphaWhite
     */
    enum SubType :Int {
        case Blue = 0 ,Red = 1,Yellow = 2, Green = 3 ,Black = 4 , AlphaWhite = 5
    }
    
    /**
     Define animation direction durning block cancellation.
     - Down
     - Left
     - Right
     - Up
     */
    enum AnimationDirection :Int {
        case Down = 4 , Left = -1 , Right = 1, Up = -4
    }

    var type :MainType!
    var subType :SubType!
    var nextBlock :Block?
    var isAvailable = true
    var counterLabel : SKLabelNode?
    var toBeCancelled = false
    var bombCounter : Int = 0 {
        didSet {
            if bombCounter > 0 {
                counterLabel?.text = String(bombCounter)
            }
        }
    }
    
    /**
     Initializer for block
     - Parameter blockRect : CGRect of the block
     - Parameter blockType : MainType of the block
     - Parameter blockSubType : SubType of the block
     */
    init(blockRect:CGRect , blockType:MainType , blockSubType:SubType?) {
        
        super.init(texture: nil, color: UIColor.clearColor(), size: blockRect.size)
        setBlockType(blockType , blockSubType:blockSubType)
        position = CGPointMake( blockRect.origin.x + blockRect.size.width/2 , blockRect.origin.y + blockRect.size.width/2 )
    }
    
    /**
     Initializer for hint block
     - Parameter nextBlockRect : CGRect of the hint block
     - Parameter blockPosition : Position on screen for hint block
     */
    init(nextBlockRect: CGRect, blockPosition: CGPoint) {
        
        super.init(texture: nil, color: UIColor.clearColor(), size: nextBlockRect.size)
        setBlockType(Block.MainType.Next , blockSubType: nil)
        position =  blockPosition
        
        /* Next node content */
        let nextBlockSize :CGFloat = nextBlockRect.size.width-25
        nextBlock = Block(blockRect: CGRectMake(-(nextBlockSize)/2,-(nextBlockSize)/2,nextBlockSize,nextBlockSize), blockType: Block.MainType.Normal , blockSubType:nil)
        addChild(nextBlock!)
        nextBlock!.PopBlockAnimation({})
    }
    
    /**
     Add bomb counter label to block and set the bomb counter randomly
     */
    func addBombCounter() {
        
        /* Preload font so it doesnt cause lag with SKLabelNode */
        let labelFont = UIFont(name: "AmericanTypewriter-Bold", size: self.size.width/2)
        counterLabel =  SKLabelNode(fontNamed: labelFont?.fontName)
        counterLabel?.fontSize = self.size.width/2
        counterLabel?.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        counterLabel?.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        counterLabel?.fontColor = UIColor.blackColor()
        counterLabel?.position = CGPointMake(0,-2)
        counterLabel?.zPosition = 5
        addChild(counterLabel!)
        bombCounter = 5 + Int(arc4random_uniform(UInt32(10)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Setup texture and color for each type of block , if blockSubType is nil then randomly choose texture
     - Parameter blockType : MainType of the block
     - Parameter blockSubType : SubType of the block
     */
    func setBlockType(blockType:MainType , blockSubType:SubType?) {
        
        type = blockType
        var randomBlockType = Int(arc4random_uniform(UInt32(4)))
        
        if blockSubType != nil {
            randomBlockType = (blockSubType?.rawValue)!
        }

        switch blockType {
        case MainType.Normal :
            subType = SubType(rawValue: randomBlockType)
            texture = TextureStore.sharedInstance.blockTextures[randomBlockType]
            zPosition = 3
            break
        case MainType.Bomb :
            subType = SubType(rawValue: randomBlockType)
            texture = TextureStore.sharedInstance.bombTextures[randomBlockType]
            zPosition = 3
            isAvailable = false
            addBombCounter()
            break
        case MainType.Background :
            subType = SubType.Black
            texture = TextureStore.sharedInstance.blockTextures[4]
            zPosition = 2
            isAvailable = false
            break
        case MainType.Next :
            subType = SubType.AlphaWhite
            texture = TextureStore.sharedInstance.blockTextures[5]
            zPosition = 1
            break
        }
        self.color = TextureStore.sharedInstance.blockColor [self.subType.rawValue]
    }
    
    /**
     SKAction when poping new block
     */
    func PopBlockAnimation(gameOverBlock:()->()) {
        
        self.hidden = false
        self.xScale = 0.5
        self.yScale = 0.5
        let scaleUpAction = SKAction.scaleTo(1.4, duration: 0.12)
        let scaleDownAction = SKAction.scaleTo(1, duration: 0.04)
        self.runAction(SKAction.sequence([scaleUpAction,scaleDownAction]), completion: { () -> Void in
            gameOverBlock()
        })
    }
    
    /**
     SKAction when poping hint block
     */
    func PopNextBlockAnimation() {
        
        self.hidden = false
        self.xScale = 1.15
        self.yScale = 1.15
        let scaleDownAction = SKAction.scaleTo(1, duration: 0.3)
        self.runAction(scaleDownAction)
    }
    
    /**
     SKAction during block cancellation
     - Parameter completion : Closure to be executing after action completed
     - Parameter direction : Direction to animate
     */
    func extendBlockAnimation(completion:()->() , direction:AnimationDirection) {
        
        let size :CGFloat = 22
        let actionDuration : NSTimeInterval = 0.15
        let pathWidth : CGFloat = self.size.width/3
        var action : SKAction!
        var pathNode : SKShapeNode!
        
        switch direction {
            
        case AnimationDirection.Down :
            pathNode = SKShapeNode(rect: CGRectMake(pathWidth / -2,(self.size.width) / -2,pathWidth,size))
            action = SKAction.moveByX(0, y: -size, duration: actionDuration)
            break
        case AnimationDirection.Up :
            pathNode = SKShapeNode(rect: CGRectMake(pathWidth / -2,self.size.width/2 - size,pathWidth,size))
            action = SKAction.moveByX(0, y: size, duration: actionDuration)
            break
        case AnimationDirection.Right :
            
            pathNode = SKShapeNode(rect: CGRectMake(self.size.width/2 - size,pathWidth / -2,size , pathWidth))
            action = SKAction.moveByX(size, y: 0, duration: actionDuration)
            break
        case AnimationDirection.Left :
            pathNode = SKShapeNode(rect: CGRectMake((self.size.width) / -2,pathWidth / -2,size,pathWidth))
            action = SKAction.moveByX(-size, y: 0, duration: actionDuration)
            break
        }
        
        pathNode.strokeColor = UIColor.clearColor()
        pathNode.fillColor = self.color
        pathNode.zPosition = -1
        self.addChild(pathNode)

        let scaleUpAction = SKAction.scaleTo(1.05, duration: 0.05)
        
        self.runAction(scaleUpAction, completion: { () -> Void in
            pathNode.runAction(action, completion: { () -> Void in
                completion()
            })
        })
    }
    
    /**
     SKAction when bomb is trigger
     - Parameter completion:   Closure to be executing after action completed
    */
    func triggerBomb(completion:()->()) {
        let scaleUpAction = SKAction.scaleBy(1.5, duration: 0.2)
        let scaleBackAction = SKAction.scaleTo(1, duration: 0.2)
        let actionSequence = SKAction.sequence([scaleUpAction,scaleBackAction,scaleUpAction])
        self.runAction(actionSequence) { () -> Void in
            self.removeAllChildren()
            self.alpha = 0
            self.subType = SubType.Black
            completion()
        }
    }
    
    /**
     SKAction after bomb is exploded
     */
    func sealBackground() {
        self.runAction(SKAction.scaleTo(0, duration: 0.4))
        runAction(SKAction.scaleTo(0, duration: 0.5)) { () -> Void in
            self.texture = TextureStore.sharedInstance.blockTextures[SubType.Black.rawValue]
            let locker = SKSpriteNode(texture: TextureStore.sharedInstance.lockTexture)
            locker.zPosition = 4
            self.addChild(locker)
            self.runAction(SKAction.scaleTo(1, duration: 0.2))
        }
    }

}
