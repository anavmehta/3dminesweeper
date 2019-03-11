// GameSceneView.swift
// Minesweeper
// Created by Anav Mehta 2/8/2019
// Copyright (c) 2019 Anav Mehta. All rights reserved
import Foundation
import UIKit
import SceneKit
import SpriteKit
import CoreGraphics
import AVFoundation
import PlaygroundSupport

extension SCNNode{
    func highlightNodeWithDuration(_ duration: TimeInterval){
        let highlightAction = SCNAction.customAction(duration: duration) { (node, elapsedTime) in
            
            let color = UIColor(red: elapsedTime/CGFloat(duration), green: CGFloat(1)-elapsedTime/CGFloat(duration), blue: 0, alpha: 1)
            let currentMaterial = self.geometry?.firstMaterial
            currentMaterial?.emission.contents = color
        }
        let unHighlightAction = SCNAction.customAction(duration: duration) { (node, elapsedTime) in
            let color = UIColor(red: CGFloat(1) - elapsedTime/CGFloat(duration), green: elapsedTime/CGFloat(duration), blue: 0, alpha: 1)
            let currentMaterial = self.geometry?.firstMaterial
            currentMaterial?.emission.contents = color
            
        }
        let pulseSequence = SCNAction.sequence([highlightAction, unHighlightAction])
        let infiniteLoop = SCNAction.repeatForever(pulseSequence)
        self.runAction(infiniteLoop)
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

class GameScene: SCNScene {
    let force = SCNVector3(x: Float.random(in: -100000 ..< 100000), y: Float.random(in: -100000 ..< 100000), z: Float.random(in: -100000 ..< 100000))
    var cameraNode: SCNNode!
    let colors: [UIColor] = [
        UIColor(displayP3Red: 0, green: 0, blue: 1, alpha: 1),         // Blue
        UIColor(displayP3Red: 0, green: 0.502, blue: 0, alpha: 1),     // Green
        UIColor(displayP3Red: 1, green: 0, blue: 0, alpha: 1),         // Red
        UIColor(displayP3Red: 0, green: 0, blue: 0.502, alpha: 1),     // Navy
        UIColor(displayP3Red: 0.502, green: 0, blue: 0, alpha: 1),     // Maroon
        UIColor(displayP3Red: 0, green: 1, blue: 1, alpha: 1),         // Aqua
        UIColor(displayP3Red: 0.502, green: 0, blue: 0.502, alpha: 1), // Purple
        UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1),         // Black
    ]
    
    
    
    
    let xoffset: Int = 4
    let yoffset: Int = 4
    let zoffset: Int = 0
    let CAMERA_ANIMATION_DURATION: TimeInterval = 1
    let cylinder = SCNCylinder(radius: 0.05, height: 0.8)
    let flag = SCNPyramid(width:0.05, height: 0.4, length:0.4)
    let grayMaterial = SCNMaterial()
    
    public var boxNodes : [SCNNode] = []
    var sphereNode: SCNNode!
    var explodedMine: SCNNode!
    let boxColor = UIColor(red: 0.9765, green: 0.9608, blue: 0.0157, alpha: 1.0)
    let greenMaterial = SCNMaterial()
    let redMaterial = SCNMaterial()
    let blueMaterial  = SCNMaterial()
    let yellowMaterial = SCNMaterial()
    let purpleMaterial = SCNMaterial()
    let whiteMaterial = SCNMaterial()
    let blackMaterial = SCNMaterial()
    let planeGeometry = SCNPlane(width: 0.05, height: 0.05)
    public var animationInProcess: Bool = false

    
    
    override init() {
        super.init()
        initialize()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    public func restart() {
        repeat{
            RunLoop.main.run(mode: .default, before: Date(timeIntervalSinceNow: 0.1))
        } while animationInProcess == true
        if(gameSceneView.prevState == .GameOver) {
            lost_physics()
            repeat{
                RunLoop.main.run(mode: .default, before: Date(timeIntervalSinceNow: 0.1))
            } while gameSceneView.prevState == .GameOver
        }
        if(gameSceneView.prevState == .Won) {
            won_physics()
            repeat{
                RunLoop.main.run(mode: .default, before: Date(timeIntervalSinceNow: 0.1))
            } while gameSceneView.prevState == .Won
        }
        
        for i:Int in 0...(numTiles-1) {
            boxNodes[i].removeAllActions()
        }
        rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }

        boxNodes.removeAll()

        initialize()
    }
    
    
    func attachNode(parentNode: SCNNode, childNode: SCNNode, first: Bool, face: Face) {
        if(Int(parentNode.position.z)+zoffset == numHeightTiles-1 && (!first || (first && face == Face.Green))) {
            let childNode_copy: SCNNode = childNode.copy() as! SCNNode
            parentNode.addChildNode(childNode_copy)
            if(first) {return}
        }
        if(Int(parentNode.position.z)+zoffset == 0 && (!first || (first && face == Face.Blue))) {
            let childNode_copy = childNode.copy() as! SCNNode
            childNode_copy.transform = SCNMatrix4Mult(childNode_copy.transform, SCNMatrix4MakeRotation(.pi, 0, 1, 0))
            parentNode.addChildNode(childNode_copy)
            if(first) {return}
        }
        if(Int(parentNode.position.y)+yoffset == numVerticalTiles-1 && (!first || (first && face == Face.Purple))) {
            let childNode_copy = childNode.copy() as! SCNNode
            childNode_copy.transform = SCNMatrix4Mult(childNode_copy.transform, SCNMatrix4MakeRotation(-.pi/2, 1, 0, 0))
            parentNode.addChildNode(childNode_copy)
            if(first) {return}
        }
        if(Int(parentNode.position.y)+yoffset == 0 && (!first || (first && face == Face.Gray))) {
            let childNode_copy = childNode.copy() as! SCNNode
            childNode_copy.transform = SCNMatrix4Mult(childNode_copy.transform, SCNMatrix4MakeRotation(.pi/2, 1, 0, 0))
            parentNode.addChildNode(childNode_copy)
            if(first) {return}
        }
        if(Int(parentNode.position.x)+xoffset == 0 && (!first || (first && face == Face.Yellow))) {
            let childNode_copy = childNode.copy() as! SCNNode
            childNode_copy.transform = SCNMatrix4Mult(childNode_copy.transform, SCNMatrix4MakeRotation(-.pi/2, 0, 1, 0))
            parentNode.addChildNode(childNode_copy)
            if(first) {return}
        }
        if(Int(parentNode.position.x)+xoffset == numHorizontalTiles-1 && (!first || (first && face == Face.Red))) {
            let childNode_copy = childNode.copy() as! SCNNode
            childNode_copy.transform = SCNMatrix4Mult(childNode_copy.transform, SCNMatrix4MakeRotation(.pi/2, 0, 1, 0))
            parentNode.addChildNode(childNode_copy)
            if(first) {return}
        }
    }
    public func discovered(id: Int){
        boxNodes[id].geometry?.materials =  [whiteMaterial,  whiteMaterial,   whiteMaterial,
                                             whiteMaterial, whiteMaterial, whiteMaterial];
        if(gameSceneView.tiles[id].minesAround == 0) {return}
        let textTodraw = SCNText(string: String(gameSceneView.tiles[id].minesAround), extrusionDepth: CGFloat(0.1))
        textTodraw.font = UIFont (name: "Arial", size: 0.9)
        textTodraw.firstMaterial?.diffuse.contents = colors[gameSceneView.tiles[id].minesAround-1]
        let textNode = SCNNode(geometry: textTodraw)
        textNode.position.x = -0.2
        textNode.position.y = -1.3
        textNode.position.z = 0.5
        attachNode(parentNode: boxNodes[id], childNode: textNode, first: false, face: .Green)
        
        
        
    }
    public func won() {
        for i:Int in 0...(numTiles-1) {
            boxNodes[i].geometry?.materials =  [whiteMaterial,  whiteMaterial,   whiteMaterial,
                                                whiteMaterial, whiteMaterial, whiteMaterial];
            boxNodes[i].highlightNodeWithDuration(0.5)
        }
        gameSceneView.playSound(sound: 4)
        gameSceneView.prevState = .Won
    }

    func createFireworks(geometry: SCNGeometry, position: SCNVector3,
                         rotation: SCNVector4) {
        let fireworks =
            SCNParticleSystem(named: "FireParticles.scnp", inDirectory:
                nil)!
        fireworks.emitterShape = geometry
        fireworks.birthLocation = .surface
        let rotationMatrix =
            SCNMatrix4MakeRotation(rotation.w, rotation.x,
                                   rotation.y, rotation.z)
        let translationMatrix =
            SCNMatrix4MakeTranslation(position.x, position.y, position.z)
        let transformMatrix =
            SCNMatrix4Mult(rotationMatrix, translationMatrix)
        scnScene.addParticleSystem(fireworks, transform: transformMatrix)
    }


    public func won_physics() {
        if(gameSceneView.animationEnabled) {
            animationInProcess = true
            rootNode.enumerateChildNodes { (node, stop) in
                node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
                node.physicsBody?.isAffectedByGravity = false
            }
            for i:Int in 0...(numTiles-1) {
                let randomMaterial = SCNMaterial()
                randomMaterial.diffuse.contents = UIColor.random()
                randomMaterial.specular.contents = UIColor.random()
                randomMaterial.emission.contents = UIColor.random()
                
                boxNodes[i].geometry?.materials =  [randomMaterial,  randomMaterial, randomMaterial,
                                                    randomMaterial, randomMaterial, randomMaterial];
            }
            let centerNode = boxNodes[223]
            
            
            centerNode.physicsBody?.applyForce(force, at: SCNVector3(x:0,y:0,z:0), asImpulse: true)
            createFireworks(geometry: centerNode.geometry!,
                            position: centerNode.presentation.position,
                            rotation: centerNode.presentation.rotation)
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.rootNode.enumerateChildNodes { (node, stop) in
                    node.physicsBody?.isAffectedByGravity = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    centerNode.removeFromParentNode()
                    gameSceneView.prevState = .Waiting
                    self.animationInProcess = false
                }
            }
        gameSceneView.playSound(sound: 4)
        } else {gameSceneView.prevState = .Waiting }
    }
    func addText(node: SCNNode, str: String) {
        let textTodraw = SCNText(string: String(str), extrusionDepth: CGFloat(0.1))
        textTodraw.font = UIFont (name: "Arial", size: 1.0)
        textTodraw.firstMaterial?.diffuse.contents = UIColor.black
        let textNode = SCNNode(geometry: textTodraw)
        textNode.position.x = -0.4
        textNode.position.y = -1.4
        textNode.position.z = 0.5
        attachNode(parentNode: node, childNode: textNode, first:false, face: .Green)
    }
    public func lost() {

        for i:Int in 0...(numTiles-1) {
            if(gameSceneView.tiles[i].state == .ExplodedMine) {

                boxNodes[i].geometry?.materials =  [redMaterial,  redMaterial,   redMaterial,
                                                    redMaterial, redMaterial, redMaterial];
                addText(node: boxNodes[i], str: "X")
                explodedMine = boxNodes[i]
                boxNodes[i].highlightNodeWithDuration(0.5)
                //boxNodes[i].physicsBody?.applyForce(force, at: SCNVector3(x:0,y:0,z:0), asImpulse: true)
                
            } else if(gameSceneView.isMine(id: i) && !gameSceneView.isFlag(id: i)) {
                boxNodes[i].geometry?.materials =  [redMaterial,  redMaterial,   redMaterial,
                                                    redMaterial, redMaterial, redMaterial];
                boxNodes[i].highlightNodeWithDuration(0.5)
            } else if(gameSceneView.tiles[i].state == .BadFlag) {
                addText(node: boxNodes[i], str: "X")
            }
            else if(gameSceneView.tiles[i].state == .Empty) {
                boxNodes[i].geometry?.materials =  [blackMaterial,  blackMaterial, blackMaterial,
                                                    blackMaterial, blackMaterial, blackMaterial];
                boxNodes[i].highlightNodeWithDuration(0.5)
            }
        }

        gameSceneView.playSound(sound: 0)
        gameSceneView.prevState = .GameOver
        
        
    }
    public func lost_physics() {
        if(gameSceneView.animationEnabled) {
            animationInProcess = true
            rootNode.enumerateChildNodes { (node, stop) in
                node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
                node.physicsBody?.isAffectedByGravity = false
            }
            
            explodedMine.physicsBody?.applyForce(force, at: SCNVector3(x:0,y:0,z:0), asImpulse: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.rootNode.enumerateChildNodes { (node, stop) in
                    node.physicsBody?.isAffectedByGravity = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    gameSceneView.prevState = .Waiting
                    self.animationInProcess = false
                }
            }
            
            gameSceneView.playSound(sound: 0)
        } else {gameSceneView.prevState = .Waiting}

    }
    public func tap(node: SCNNode) {
        /*repeat{
            RunLoop.main.run(mode: .default, before: Date(timeIntervalSinceNow: 0.1))
        } while scnScene.animationInProcess == true*/
        if(gameSceneView.prevState == .GameOver || gameSceneView.prevState == .Won) {
            gameSceneView.restart()
            return
        }
        if(Int(node.position.x)+xoffset == gameSceneView.hintX && Int(node.position.y)+yoffset == gameSceneView.hintY && Int(node.position.z)+zoffset == gameSceneView.hintZ && gameSceneView.hintType == MINE) || (gameSceneView.isFlag(id: gameSceneView.getId(x: Int(node.position.x)+xoffset, y: Int(node.position.y)+yoffset, z: Int(node.position.z)+zoffset))) {
            longTap(node:node)
            return
            
        }
        clearHint()
        gameSceneView.playSound(sound:3)
        gameSceneView.tap(x: Int(node.position.x)+xoffset, y: Int(node.position.y)+yoffset, z: Int(node.position.z))
        
        
    }
    public func addFlag(id: Int){
        let node: SCNNode = boxNodes[id]
        let cylinderNode = SCNNode(geometry: cylinder)
        cylinderNode.position.x = Float(0.0)
        cylinderNode.position.y = Float(0.0)
        cylinderNode.position.z = Float(0.8)
        cylinderNode.pivot = SCNMatrix4MakeRotation(.pi/2, 1, 0, 0)
        let flagNode = SCNNode(geometry: flag)
        flagNode.position.x = Float(0.0)
        flagNode.position.y = Float(0.0)
        flagNode.position.z = Float(1.0)
        attachNode(parentNode: node, childNode: cylinderNode, first: false, face: .Green)
        attachNode(parentNode: node, childNode: flagNode, first: false, face: .Green)
    }
    public func removeFlag(id: Int) {
        let node: SCNNode = boxNodes[id]
        for childNode in node.childNodes {
            childNode.removeFromParentNode()
        }
        
    }
    public func longTap(node: SCNNode) {
        /*repeat{
            RunLoop.main.run(mode: .default, before: Date(timeIntervalSinceNow: 0.1))
        } while animationInProcess == true*/
        if(gameSceneView.state == .Waiting) || (Int(node.position.x)+xoffset == gameSceneView.hintX && Int(node.position.y)+yoffset == gameSceneView.hintY && Int(node.position.z)+zoffset == gameSceneView.hintZ && gameSceneView.hintType == SAFE) {
            tap(node: node)
            return
        }
        clearHint()

        gameSceneView.longTap(x: Int(node.position.x)+xoffset, y: Int(node.position.y)+yoffset, z: Int(node.position.z)+zoffset)

    }

    func getCameraTransform(position: SCNVector3) -> (SCNVector3, SCNVector3){
        var pos: SCNVector3!
        var rot: SCNVector3!

        if(Int(position.z+Float(zoffset)) == 7) {
            pos = SCNVector3(position.x,position.y,Float(16))
            rot = SCNVector3Make(0,0,0)
        }
        if(Int(position.z+Float(zoffset)) == 0) {
            pos = SCNVector3(position.x,position.y,Float(-8))
            rot = SCNVector3Make(0,.pi,0)
        }
        if(Int(position.x+Float(xoffset)) == 0) {
            pos = SCNVector3(Float(-12),position.y,position.z)
            rot = SCNVector3Make(0,-.pi/2,0)
        }
        if(Int(position.x+Float(xoffset)) == 7){
            pos = SCNVector3(Float(12),position.y,position.z)
            rot = SCNVector3Make(0,.pi/2,0)
        }
        if(Int(position.y+Float(yoffset)) == 0) {
            pos = SCNVector3(position.x,Float(-12),position.z)
            rot = SCNVector3Make(.pi/2,0,0)
        }
        if(Int(position.y+Float(yoffset)) == 7) {
            pos = SCNVector3(position.x,Float(12),position.z)
            rot = SCNVector3Make(-.pi/2,0,0)
        }
        return (pos,rot)
        
    }


    func resetCameraToDefaultPosition() {
        scnView.pointOfView?.position = SCNVector3(x: 0, y: 0, z: 18)
        scnView.pointOfView?.eulerAngles = SCNVector3Make(0,0,0)
    }
    
    func rotateCamera() {
        scnView.allowsCameraControl = false
        let (pos, rot) = getCameraTransform(position:sphereNode.position)
        scnView.pointOfView?.position = pos
        scnView.pointOfView?.eulerAngles = rot
        scnView.allowsCameraControl = true

    }
    public func hint() {
        if(gameSceneView.hintType != -1){
            resetCameraToDefaultPosition()
            if(gameSceneView.hintType == SAFE) {
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.green
                sphereNode.geometry?.firstMaterial?.specular.contents = UIColor.green
                sphereNode.geometry?.firstMaterial?.emission.contents = UIColor.green
            } else {
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                sphereNode.geometry?.firstMaterial?.specular.contents = UIColor.red
                sphereNode.geometry?.firstMaterial?.emission.contents = UIColor.red
            }
            sphereNode.position.x = Float(gameSceneView.hintX - xoffset)
            sphereNode.position.y = Float(gameSceneView.hintY - yoffset)
            sphereNode.position.z = Float(gameSceneView.hintZ - zoffset)
            sphereNode.highlightNodeWithDuration(0.25)

            rotateCamera()
            /*scnView.allowsCameraControl = false
            SCNTransaction.begin()
            let lookAtConstraint = SCNLookAtConstraint(target:sphereNode)
            scnView.pointOfView!.constraints = [lookAtConstraint]
            SCNTransaction.animationDuration = 1.0
            SCNTransaction.commit()
            scnView.allowsCameraControl = true*/

            
        } else {
            sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
            sphereNode.geometry?.firstMaterial?.specular.contents = UIColor.clear
            sphereNode.geometry?.firstMaterial?.emission.contents = UIColor.clear
        }
    }
    func clearHint() {
        sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        sphereNode.geometry?.firstMaterial?.specular.contents = UIColor.clear
        sphereNode.geometry?.firstMaterial?.emission.contents = UIColor.clear
    }
    func addOrigin(node: SCNNode, face: Face) {
        let textTodraw = SCNText(string: String("O"), extrusionDepth: CGFloat(0.1))
        textTodraw.font = UIFont (name: "Arial", size: 0.3)
        textTodraw.firstMaterial?.diffuse.contents = UIColor.black
        let textNode = SCNNode(geometry: textTodraw)
        textNode.position.x = -0.2
        textNode.position.y = -1.2
        textNode.position.z = 0.5
        attachNode(parentNode: node, childNode: textNode, first:true, face: face)
    }
    
    func initialize() {

        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 18)
        self.rootNode.addChildNode(cameraNode)
        scnView.pointOfView = cameraNode
        
        grayMaterial.diffuse.contents = UIColor.gray
        //grayMaterial.specular.contents = UIColor.gray
        //grayMaterial.emission.contents = UIColor.gray
        grayMaterial.locksAmbientWithDiffuse = true;
        
        cylinder.firstMaterial?.diffuse.contents = UIColor.black
        cylinder.firstMaterial?.specular.contents = UIColor.white
        cylinder.firstMaterial?.emission.contents = UIColor.gray
        
        flag.firstMaterial?.diffuse.contents = UIColor.red
        flag.firstMaterial?.specular.contents = UIColor.red
        flag.firstMaterial?.emission.contents = UIColor.red
        sphereNode = SCNNode(geometry: SCNSphere(radius: 0.6))
        sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        sphereNode.geometry?.firstMaterial?.specular.contents = UIColor.clear
        sphereNode.geometry?.firstMaterial?.emission.contents = UIColor.clear
        //sphereNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        sphereNode.categoryBitMask = 0x02
   
        greenMaterial.diffuse.contents = UIColor.green
        greenMaterial.specular.contents = UIColor.green
        greenMaterial.emission.contents = UIColor.green
        greenMaterial.locksAmbientWithDiffuse = true;
        redMaterial.diffuse.contents = UIColor.red
        redMaterial.locksAmbientWithDiffuse = true;
        blueMaterial.diffuse.contents = UIColor.blue
        blueMaterial.locksAmbientWithDiffuse = true;
        yellowMaterial.diffuse.contents = UIColor.yellow
        yellowMaterial.locksAmbientWithDiffuse = true;
        purpleMaterial.diffuse.contents = UIColor.purple
        purpleMaterial.locksAmbientWithDiffuse = true;
        whiteMaterial.diffuse.contents = UIColor.white
        whiteMaterial.locksAmbientWithDiffuse   = true;
        blackMaterial.diffuse.contents = UIColor.black
        blackMaterial.locksAmbientWithDiffuse   = true;
        
        self.rootNode.addChildNode(sphereNode)
        
        for z:Int in 0...(numHeightTiles-1) {
            for y:Int in 0...(numVerticalTiles-1) {
                for x:Int in 0...(numHorizontalTiles-1) {
                    let geometry = SCNBox(width: 1.0 , height: 1.0,
                                          length: 1.0, chamferRadius: 0.1)
                    geometry.materials =  [greenMaterial,  redMaterial,    blueMaterial,
                                           yellowMaterial, purpleMaterial, grayMaterial];
                    
                    let boxCopy = SCNNode(geometry: geometry)
                    boxNodes.append(boxCopy)
                    boxCopy.position.x = Float(x - xoffset)
                    boxCopy.position.y = Float(y - yoffset)
                    boxCopy.position.z = Float(z - zoffset)
                    boxCopy.categoryBitMask = 0x01
                   
                    self.rootNode.addChildNode(boxCopy)
                    
                    for i in 0...5 {
                        let (face, x_,y_,z_) = origins[i]
                        if(x_ == x && y == y_ && z == z_) {
                            addOrigin(node: boxCopy, face: face)
                        }
                    }
                }
            }
        }
    }
    
}


