//
//  TextureContainer.swift
//  BombBlocksSwift
//
//  Created by JackYeh on 2016/3/4.
//  Copyright © 2016年 MarriageKiller. All rights reserved.
//
import SpriteKit

class TextureStore {
    
    static let  sharedInstance = TextureStore()
    
    var blockTextures = [SKTexture]()
    var bombTextures = [SKTexture]()
    var lockTexture :SKTexture?    
    var blockColor = [
        UIColor(red: 0/255, green: 146/255, blue: 199/255, alpha: 1) ,
        UIColor(red: 242/255, green: 75/255, blue: 106/255, alpha: 1),
        UIColor(red: 242/255, green: 185/255, blue: 80/255, alpha: 1),
        UIColor(red: 65/255, green: 167/255, blue: 116/255, alpha: 1),
        UIColor.blackColor(),
        UIColor(white: 0.15, alpha: 1)
    ]
    
    private init() {

    }
    
    func createStore(size:CGSize) {
        /* Create Normal block textures */
        for colorIndex in 0...blockColor.count-1 {
            blockTextures.append(createBlockTexture(size, color: blockColor[colorIndex],subImage: nil))
        }
        
        /* Create Bomb textures */
        for colorIndex in 0...3 {
            bombTextures.append(createBombTexture(size, color: blockColor[colorIndex]))
        }
        
        lockTexture = createLockTexture(size)
    }
    
    private func createBlockTexture(size:CGSize , color:UIColor , subImage:UIImage?)->SKTexture {
        
        UIGraphicsBeginImageContext(size);
        color.setFill()
        let path = UIBezierPath(roundedRect: CGRectMake(0, 0, size.width, size.height), cornerRadius: size.width/4)
        path.fill()
        
        if let image = subImage {
            image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        }
        let baseImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return SKTexture(image: baseImage)
    }
    
    func createBombTexture(size:CGSize , color:UIColor)->SKTexture {
        
        let bombSizeModifer :CGFloat = CGFloat(16 * Int(UIScreen.mainScreen().bounds.width / 320))
        let bombOvalSize : CGFloat = size.width - bombSizeModifer
        
        UIGraphicsBeginImageContext(size);
        UIColor(white: 1, alpha: 1).setFill()
        let bombPath = UIBezierPath(ovalInRect: CGRectMake(bombSizeModifer/2, bombSizeModifer/2 + 2, bombOvalSize, bombOvalSize))
        let rectPath = UIBezierPath(roundedRect: CGRectMake((size.width - size.width/5)/2, bombSizeModifer/4, size.width/5, CGFloat(25 * Int(UIScreen.mainScreen().bounds.width / 320))), cornerRadius: size.width/5/4)
        bombPath.appendPath(rectPath)
        bombPath.fill()
        let bombImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
       
        return createBlockTexture(size, color:color , subImage: bombImage)
    }
    
    func createLockTexture(size:CGSize)->SKTexture {
        
        /* Sizes */
        let sizeModifier : CGFloat = size.width/1.7
        let lockHeight = size.width - sizeModifier
        let lockWidth  = lockHeight * 1.3
        let ringRadius = lockWidth/2
        let holeRadius : CGFloat = ringRadius - 8
        let holeWidth = holeRadius * 0.6
        let yOffset :CGFloat = -4

        /* Hole image */
        UIGraphicsBeginImageContext(size);
        UIColor.blackColor().setFill()
        
        let holePath = UIBezierPath(arcCenter: CGPointMake(size.width/2, size.width/2 + yOffset), radius: holeRadius, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: false)
        holePath.appendPath(UIBezierPath(rect: CGRectMake((size.width - holeWidth)/2, (size.width+holeWidth)/2 , holeWidth, holeWidth)))
        holePath.appendPath(UIBezierPath(ovalInRect: CGRectMake( size.width/2 - holeRadius * 1.25/2 ,size.height/2 + (holeRadius * 1.25)/2, holeRadius * 1.25, holeRadius * 1.25)))
        holePath.fill()
        let holeImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        /* Lock image */
        UIGraphicsBeginImageContext(size);
        UIColor.whiteColor().setFill()
        let lockPath = UIBezierPath(arcCenter: CGPointMake((size.width - lockWidth)/2 + lockWidth/2 , size.width - lockWidth + yOffset), radius: ringRadius, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: false)
        lockPath.appendPath( UIBezierPath(rect: CGRectMake( (size.width - lockWidth)/2, size.width - lockWidth + yOffset, lockWidth, lockHeight)))
        lockPath.fill()
        holeImage.drawInRect(CGRectMake(0, -3, size.width, size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return SKTexture(image: image)
    }
    
    func createKeyTexture(size:CGSize)->SKTexture {

        /* Sizes */
        let lockHeight : CGFloat = size.width/8
        let lockWidth  : CGFloat = size.width/2.4
        let radius : CGFloat = size.width/4.5
        let ringRadius = radius - 8
        
        /* Ring image */
        UIGraphicsBeginImageContext(size);
        UIColor.blackColor().setFill()
        let ringPath = UIBezierPath(ovalInRect: CGRectMake(8 + radius - ringRadius , size.height/2 - ringRadius, ringRadius * 2, ringRadius * 2))
        ringPath.fill()
        let ringImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        /* Key image */
        UIGraphicsBeginImageContext(size);
        UIColor.whiteColor().setFill()
        let finalPath = UIBezierPath(ovalInRect: CGRectMake(8 , size.height/2 - radius, radius * 2, radius * 2))
        finalPath.appendPath(UIBezierPath(rect: CGRectMake(4 + radius * 2, (size.height - lockHeight)/2, lockWidth, lockHeight)))
        finalPath.appendPath(UIBezierPath(rect: CGRectMake(4 + radius * 2 + lockWidth - 13 , (size.height - lockHeight)/2 + 8, lockHeight - 2 , 10)))
        finalPath.fill()
        ringImage.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let keyImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return SKTexture(image: keyImage)
    }

}
