// Common.swift
// Minesweeper
// Created by Anav Mehta 2/8/2019
// Copyright (c) 2019 Anav Mehta. All rights reserved
import Foundation
import UIKit
import PlaygroundSupport


public let numHorizontalTiles: Int = 8
public let numVerticalTiles: Int = 8
public let numHeightTiles: Int = 8
public let numTiles: Int = 8*8*8
public let numValidTiles: Int = 8*8*8-6*6*6
public let size: Int = 40
public let tileSize: Int = 40
public var maxMines: Int = 250
public let width = 480
public let height = 360
public let UNKNOWN = -1
public let FLAGGEDMINE = 1
public let MINE = 1
public let SAFE = 2
public let EXPLODEDMINE = 3
public enum Face {
    case Green
    case Red
    case Yellow
    case Gray
    case Blue
    case Purple
}
public let origins: [(Face,Int,Int,Int)] = [
    (.Green,0,0,7),
    (.Yellow,0,0,0),
    (.Blue,7,0,0),
    (.Red,7,0,7),
    (.Purple,0,7,7),
    (.Gray,0,0,0)
]

struct PlayGroundVars {

    public var hintX: Int! = -1
    public var hintY: Int! = -1
    public var hintZ: Int! = -1
    public var hintType: Int! = -1
    public var soundEnabled: Bool = true
    public var numMines: Int! = -1
    public var status: Int! = -1
    public var response: Bool = false
}
var playGroundVars: PlayGroundVars = PlayGroundVars()



let proxy = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy
public class PlaygroundListener: PlaygroundRemoteLiveViewProxyDelegate {
    public static let shared = PlaygroundListener()
    
    public func setup() {
        if let proxy = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy {
            proxy.delegate = self
        }
    }
    public func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy,
                                    received message: PlaygroundValue) {
        switch message {
        case let .string(text):
            let strArr = text.split(separator: " ")
            switch strArr[0] {
            case "hint":
                playGroundVars.hintX = Int(strArr[1])!
                playGroundVars.hintY = Int(strArr[2])!
                playGroundVars.hintZ = Int(strArr[3])!
                playGroundVars.hintType = Int(strArr[4])!
            case "mines":
                playGroundVars.numMines = Int(strArr[1])!
            case "status":
                playGroundVars.status = Int(strArr[1])!
            default:
                print("Not a recognized command")
            }
        default:
            print("A valid message not received")
        }
        playGroundVars.response = true
    }
    public func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) {
        PlaygroundPage.current.finishExecution()
    }
}
public func translateToFace(x: Int, y: Int, z: Int) -> (Int, Int, Face) {
    var x_n:Int!
    var y_n:Int!
    var face:Face!
    x_n = x
    y_n = y
    face = .Green
    if(z == 8) {
        x_n = x
        y_n = y
        face = .Green
    }
    if(x == 1) {
        x_n = z
        y_n = y
        face = .Yellow
    }
    if(z == 1) {
        x_n = numHorizontalTiles - x + 1
        y_n = y
        face = .Blue
    }
    if(x == numHorizontalTiles) {
        x_n = numHeightTiles - z + 1
        y_n = y
        face = .Red
    }
    if(y == numVerticalTiles) {
        x_n = x
        y_n = numHeightTiles - z + 1
        face = .Purple
    }
    if(y == 1) {
        x_n = x
        y_n = z
        face = .Gray
    }
    return (x_n, y_n, face)
}
public func translate(x: Int, y: Int, face: Face) -> (Int, Int, Int){
    var x_n:Int!
    var y_n:Int!
    var z_n:Int!
    if(face == .Green) {
        x_n = x
        y_n = y
        z_n = numHeightTiles
    }
    if (face == .Yellow) {
        x_n = 1
        y_n = y
        z_n = x
    }
    if (face == .Blue) {
        x_n = numHorizontalTiles-x+1
        y_n = y
        z_n = 1
    }
    if (face == .Red) {
        x_n = numHorizontalTiles
        y_n = y
        z_n = numHeightTiles - x+1
    }
    if (face == .Purple) {
        x_n = x
        y_n = numVerticalTiles
        z_n = numHeightTiles - y + 1
    }
    if (face == .Gray) {
        x_n = x
        y_n = 1
        z_n = y
    }
    return (x_n, y_n, z_n)
    
}
public func play() {
    proxy?.send(.string("play"))
}

public func tap(x: Int, y: Int, face: Face) {
    let (x_n, y_n, z_n) = translate(x:x, y:y, face:face)
    proxy?.send(.string("tap "+String(x_n)+" "+String(y_n)+" "+String(z_n)))
}

public func tapped(x: Int, y: Int) {
}

public func sound(enabled: Bool) {
    proxy?.send(.string("sound "+String(enabled)))
}

public func animation(enabled: Bool) {
    proxy?.send(.string("animation "+String(enabled)))
}


public func flag(x: Int, y: Int, face: Face) {
    let (x_n, y_n, z_n) = translate(x:x, y:y, face:face)
    proxy?.send(.string("flag "+String(x_n)+" "+String(y_n)+" "+String(z_n)))
}

public func setMineDensity(percentage: Int) {
    if(percentage <= 0  || percentage > 100) {return}
    proxy?.send(.string("setMineDensity "+String(percentage)))
}

public func hint() -> (Int, Int, Face, Int){
    playGroundVars.response = false
    proxy?.send(.string("hint"))
    repeat{
        RunLoop.main.run(mode: .default, before: Date(timeIntervalSinceNow: 0.1))
        
    } while playGroundVars.response == false
    let (x_n, y_n, face) = translateToFace(x:playGroundVars.hintX, y:playGroundVars.hintY, z:playGroundVars.hintZ)
    return(x_n, y_n, face, playGroundVars.hintType)
    
}
public func mines() -> (Int) {
    proxy?.send(.string("mines"))
    repeat{
        RunLoop.main.run(mode: .default, before: Date(timeIntervalSinceNow: 0.1))
    } while playGroundVars.response == false
    return(playGroundVars.numMines)
}

public func status(x: Int, y: Int, face: Face) -> (Int) {
    playGroundVars.response = false
    let (x_n, y_n, z_n) = translate(x:x, y:y, face:face)
    proxy?.send(.string("status "+String(x_n)+" "+String(y_n)+" "+String(z_n)))
    repeat{
        RunLoop.main.run(mode: .default, before: Date(timeIntervalSinceNow: 0.1))
    } while playGroundVars.response == false
    return playGroundVars.status
}

