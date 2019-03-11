// ViewControllerGameScene.swift
// Minesweeper
// Created by Anav Mehta 2/8/2019
// Copyright (c) 2019 Anav Mehta. All rights reserved

import Foundation
import SceneKit
import UIKit
import PlaygroundSupport

var scnView: SCNView! = SCNView()
var gameSceneView: GameSceneView! = GameSceneView()
var scnScene: GameScene! = GameScene()

public var headerView: HeaderView! = HeaderView(frame: CGRect(x: 0, y: 60, width: width, height: tileSize))
public class ViewController : UIViewController, PlaygroundLiveViewMessageHandler, UIGestureRecognizerDelegate, SCNSceneRendererDelegate {
    //var scnView: SCNView! = SCNView()

    var spawnTime: TimeInterval = 0
    var tappedNode: SCNNode!
   
    var defaultGestures: [UIGestureRecognizer]!
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        return false
    }
    public override func loadView() {
        super.loadView()
    }
    func setAutoLayoutConstraints() {
        //: Auto Layout Code
        //Autolayout for the view.
        headerView.translatesAutoresizingMaskIntoConstraints  = false
        scnView.translatesAutoresizingMaskIntoConstraints = false
        var constraints:[NSLayoutConstraint] = []
        
        constraints += [NSLayoutConstraint.init(item: headerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 62.0)]
        constraints += [NSLayoutConstraint.init(item: headerView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.0, constant: CGFloat(tileSize))]
        constraints += [NSLayoutConstraint.init(item: headerView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.0, constant: CGFloat(width))]
        headerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        constraints += [NSLayoutConstraint.init(item: scnView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.0, constant: CGFloat(height))]
        constraints += [NSLayoutConstraint.init(item: scnView, attribute: .top, relatedBy: .equal, toItem: headerView, attribute: .bottom, multiplier: 1.0, constant: 0.0)]
        constraints += [NSLayoutConstraint.init(item: scnView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.0, constant: CGFloat(width))]
        scnView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addConstraints(constraints)
    }
   
    public override func viewDidLoad() {
        super.viewDidLoad()
        //scnView = SCNView()
        scnView.frame = CGRect(x:0, y:0, width: 480, height:self.view.frame.height)
        headerView.backgroundColor = .gray
        self.view.addSubview(scnView)
        self.view.addSubview(headerView)

        
        // set the scene to the view
        scnView.scene = scnScene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true


        
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
        tapRec.numberOfTapsRequired = 1
        
        let longTapRec = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap(rec:)))
        longTapRec.minimumPressDuration = 0.25
        longTapRec.allowableMovement = 15 // 15 points
        longTapRec.delaysTouchesBegan = true
        //Add recognizer to sceneview
        scnView.addGestureRecognizer(tapRec)
        scnView.addGestureRecognizer(longTapRec)
        
        // show statistics such as fps and timing information
        //scnView.showsStatistics = true
        scnView.autoenablesDefaultLighting = true
        // configure the view
        scnView.backgroundColor = UIColor(red: 0, green: 0.9882, blue: 0.9373, alpha: 1.0) /* #00fcef */
        setAutoLayoutConstraints()
        scnView.play(nil)
        
        
    }

    

    
    //Method called when tap
    @objc func handleTap(rec: UITapGestureRecognizer){
        
        if rec.state == .ended {
            let location: CGPoint = rec.location(in: scnView)
            //let hits = self.scnView.hitTest(location, options: [SCNHitTestOption.categoryBitMask : 0x01])
            let hits = scnView.hitTest(location, options: [SCNHitTestOption.categoryBitMask : 0x01])
            if !hits.isEmpty{
                tappedNode = hits.first?.node
                scnScene.tap(node: tappedNode)
            }
        }
    }
    
    @objc func handleLongTap(rec: UILongPressGestureRecognizer){
        
        if rec.state == .ended {
            let location: CGPoint = rec.location(in: scnView)
            //let hits = self.scnView.hitTest(location, options: [SCNHitTestOption.categoryBitMask : 0x01])
            let hits = scnView.hitTest(location, options: [SCNHitTestOption.categoryBitMask : 0x01])
            if !hits.isEmpty{
                tappedNode = hits.first?.node
                scnScene.longTap(node: tappedNode)

            }
        }
    }
    public func liveViewMessageConnectionOpened() {}
    
    public func liveViewMessageConnectionClosed() {}
    

    public func receive(_ message: PlaygroundValue) {
        var x: Int! = -1
        var y: Int! = -1
        var z: Int! = -1
        var a: Int! = -1
        var status: Int! = -1
        switch message {
        case let .string(text):
            let strArr = text.split(separator: " ")
            switch strArr[0] {
            case "play":
                gameSceneView.play()
            case "hint":
                (x!,y!,z!, a!) = gameSceneView.hint()
                self.send(.string("hint " + String(x!+1) + " " + String(y!+1) + " " + String(z!+1) + " " + String(a)))
            case "setMineDensity":
                headerView.setMineDensity(percentage: Int(strArr[1])!)
            case "sound":
                if(strArr[1] == "true") {gameSceneView.sound(enabled: true)}
                else {gameSceneView.sound(enabled: false)}
            case "animation":
                if(strArr[1] == "true") {gameSceneView.animation(enabled: true)}
                else {gameSceneView.animation(enabled: false)}
            case "tap":
                gameSceneView.tap(x: Int(strArr[1])!-1, y: Int(strArr[2])!-1, z: Int(strArr[3])!-1)
            case "flag":
                gameSceneView.flag(x: Int(strArr[1])!-1, y: Int(strArr[2])!-1, z: Int(strArr[3])!-1)
            case "mines":
                self.send(.string("mines " + String(gameSceneView.numMines - gameSceneView.flags)))
            case "status":
                status = gameSceneView.status(x: Int(strArr[1])!-1, y: Int(strArr[2])!-1, z: Int(strArr[3])!-1)
                self.send(.string("status "+String(status!)))
            default:
                print("Not a recognized command")
            }
        default:
            print("A valid message not received")
        }
        
    }
}




