// GameSceneView.swift
// Minesweeper
// Created by Anav Mehta 2/8/2019
// Copyright (c) 2019 Anav Mehta. All rights reserved
import Foundation
import UIKit
import SceneKit
import AVFoundation
import PlaygroundSupport



public var timer = Timer()

public class Tile {
    public enum State {
        case Empty
        case Discovered
        case Flagged
        case BadFlag
        case ExplodedMine
        case Mine
        case FlaggedMine
    }
    
    public var x: Int
    public var y: Int
    public var z: Int
    public var state = State.Empty
    public var minesAround = 0
    
    init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
}

public class GameSceneView {
    public var randomization: Bool = true
    
    public var numMines: Int = maxMines/2
    public var boardType: Int = 1
    public var animationEnabled: Bool = true
    
    public var hintX: Int! = -1
    public var hintY: Int! = -1
    public var hintZ: Int! = -1
    public var hintType: Int! = -1
    var audioPlayer: AVAudioPlayer!
    let audioFilePathMine = Bundle.main.path(forResource:"Bomb+4", ofType: "mp3")
    let audioFilePathFlag = Bundle.main.path(forResource:"spade_hit_4", ofType: "mp3")
    let audioFilePathSafe = Bundle.main.path(forResource:"mallert 008", ofType: "mp3")
    let audioFilePathWon = Bundle.main.path(forResource:"crowd", ofType: "mp3")
    let audioFilePathLost = Bundle.main.path(forResource:"lost", ofType: "mp3")
    public var soundEnabled: Bool = true
    
    public var dx: [Int] = [-1,-1,-1,-1,-1,-1,-1,-1,-1, 0, 0, 0, 0, 0, 0, 0, 0,  1, 1, 1, 1, 1, 1, 1, 1, 1]
    public var dy: [Int] = [-1,-1,-1, 0, 0, 0, 1, 1, 1,-1,-1,-1, 0, 0, 1, 1, 1, -1,-1,-1, 0, 0, 0, 1, 1, 1]
    public var dz: [Int] = [-1, 0, 1,-1, 0, 1,-1, 0, 1,-1, 0, 1,-1, 1,-1, 0, 1, -1, 0, 1,-1, 0, 1,-1, 0, 1]
    public var data: [Bool] = Array(repeating: false, count: 8*8*8)
    public var seconds: Int = 0
    public var flags: Int = 0
    public var safe: Int = 0
    public var tiles: [Tile] = []
    
    public enum State {
        case Waiting
        case GameOver
        case Won
        case Playing
    }
    public var state = State.Waiting
    public var prevState = State.Waiting
    public func initialize() {
        seconds = 0
        flags = 0
        safe = 0
        state = State.Waiting
        prevState = State.Waiting
        var i:Int = 0
        for z:Int in 0...(numHeightTiles-1) {
            for y:Int in 0...(numVerticalTiles-1) {
                for x:Int in 0...(numHorizontalTiles-1) {
                    let t = Tile(x: x, y: y, z: z)
                    t.state = .Empty
                    tiles.append(t)
                    data[i]=false
                    i = i+1
                }
            }
        }
    }
    public func getId(x: Int, y: Int, z: Int) -> Int {
        return z * numVerticalTiles * numHorizontalTiles + y * numHorizontalTiles + x
    }
    public func sound(enabled: Bool) {
        soundEnabled = enabled
    }
    public func animation(enabled: Bool) {
        animationEnabled = enabled
    }
    
    public func getXYZ(id: Int) -> (Int, Int, Int) {
        let z = id / (numVerticalTiles * numHorizontalTiles)
        let y = (id - z * numVerticalTiles * numHorizontalTiles) / numHorizontalTiles
        let x = id - y * numHorizontalTiles - z * numVerticalTiles * numHorizontalTiles
        return (x, y, z)
    }
    
    public func isMine(id: Int) -> Bool {
        return data[id]
    }
    
    public func isFlag(id: Int) -> Bool {
        return tiles[id].state == .Flagged
    }
    
    func playSound(sound: Int) {
        var audioFilePath: String!
        if(!soundEnabled) {return}
        if(sound == 0) {
            audioFilePath = audioFilePathMine
        } else if(sound == 1) {
            audioFilePath = audioFilePathFlag
        } else if (sound == 2){
            audioFilePath = audioFilePathSafe
        } else if (sound == 3) {
            audioFilePath = audioFilePathSafe
        } else if (sound == 4) {
            audioFilePath = audioFilePathWon
        } else if (sound == 5) {
            audioFilePath = audioFilePathLost
        }
        if audioFilePath != nil {
            
            let audioFileUrl = NSURL.fileURL(withPath: audioFilePath!)
            do {
                audioPlayer = try AVAudioPlayer.init(contentsOf: audioFileUrl)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.play()
            }
            catch let error {
                print(error.localizedDescription)
            }
            
        } else {
            print("audio file is not found")
        }
    }
    public func isValid(x: Int, y: Int, z: Int) -> Bool {
        let onSurface = x >= 0 && x < numHorizontalTiles &&
            y >= 0 && y < numVerticalTiles &&
            z >= 0 && z < numHeightTiles
        let inside = x > 0 && x < numHorizontalTiles - 1 &&
            y > 0 && y < numVerticalTiles - 1 &&
            z > 0 && z < numHeightTiles - 1
        return onSurface && !inside
    }
    
    func calc_or_set(x: Int, y: Int, z: Int, c: Int, a: Int) -> Int{
        var count = 0;
        var id = 0;
        for i in 0..<26 {
            if(isValid(x: x+dx[i], y: y+dy[i], z:z+dz[i])) {
                id=getId(x:x+dx[i],y:y+dy[i],z:z+dz[i])
                if ((c == MINE && isFlag(id:id) && isMine(id:id)) || ((c==UNKNOWN) && tiles[id].state == .Empty)) {
                    count = count + 1
                    if(a != 0 ) {
                        hintX = x+dx[i]
                        hintY = y+dy[i]
                        hintZ = z+dz[i]
                        hintType = a
                        return count
                    }
                }
            }
        }
        return count
    }
    
    func infer(x: Int, y: Int, z: Int) -> Bool{
        let id = getId(x:x, y:y, z:z)
        let n = tiles[id].minesAround
        
        var unknown = 0;
        var mines = 0;
        var ret = 0;
        if (n >= 0 && n <= 9) {
            unknown = calc_or_set(x:x, y:y, z:z, c:UNKNOWN, a:0)
            mines = calc_or_set(x:x, y:y, z:z, c:MINE, a:0)
            if (unknown == n - mines) {
                ret=calc_or_set(x:x, y:y, z:z, c:UNKNOWN, a:MINE)
                if(ret > 0) {
                    return true
                }
            }
            if (mines == n) {
                ret=calc_or_set(x:x, y:y, z:z, c:UNKNOWN, a:SAFE)
                if(ret > 0) {
                    return true
                }
            }
        }
        return false
    }
    public func hint() -> (Int, Int, Int, Int)  {
        hintX = UNKNOWN
        hintY = UNKNOWN
        hintZ = UNKNOWN
        hintType = UNKNOWN
        
        for x in 0..<numHorizontalTiles {
            for y in 0..<numVerticalTiles {
                for z in 0..<numHeightTiles {
                    if(!isValid(x:x,y:y,z:z)) {continue}
                    
                    let id=getId(x:x, y:y, z:z)
                    if(tiles[id].state == .Discovered) {
                        if(infer(x:x, y:y, z:z)) {
                            playSound(sound: 3)
                            if(animationEnabled) {scnScene.hint()}
                            return(hintX, hintY, hintZ, hintType)
                        }
                    }
                }
            }
        }
        
        return (hintX,hintY,hintZ, hintType)
    }
    
    public func tap(x: Int, y: Int, z: Int) {
       
        if state == State.Waiting {
            initBoard(x: x, y: y, z: z)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
            if(!randomization) {
                return
            }
        }
        
        if state == State.Playing {
            showTile(x: x, y: y, z: z, tap: true)


        } else if state == .GameOver || state == .Won {
            reset()
            state = .Waiting
            timer.invalidate()
            setup()
        }
    }
    
    func won() {
        state = .Won
        if(animationEnabled) {
            scnScene.won()
            headerView.setWinView()
        }
        showMines(deadId: -1)

        timer.invalidate()

    }
    
    public func setup() {
        if(!randomization) {setBoard()}
    }
    
    public func longTap(x: Int, y: Int, z: Int) {
        if state == State.Waiting {
            tap(x:x,y:y,z:z)
        }
        
        if state == State.Playing {
            showTile(x: x, y: y, z: z, tap: false)
        } else if state == .GameOver || state == .Won {
            reset()
            state = .Waiting
            timer.invalidate()
            setup()
        }
        
    }
    @objc public func updateTimer() {
        seconds += 1
        headerView.timerLbl.text = String(format: "%d", seconds)
        headerView.timerLbl.sizeToFit()

    }
    public func setBoard() {
        if(boardType == 1) {
            soundEnabled = false
            randomization = false
            setNumMines(val: 0)
            addMine(x:1,y:1,z:7)
            addMine(x:1,y:2,z:7)
            addMine(x:1,y:3,z:7)
            addMine(x:4,y:6,z:7)
            addMine(x:4,y:7,z:7)
            addMine(x:5,y:6,z:7)
            addMine(x:5,y:7,z:7)
            addMine(x:6,y:6,z:7)
            addMine(x:6,y:7,z:7)
            addMine(x:5,y:0,z:7)
            addMine(x:5,y:1,z:7)
            addMine(x:6,y:0,z:7)
            addMine(x:6,y:1,z:7)
            addMine(x:7,y:0,z:7)
            addMine(x:7,y:1,z:7)
            
            addMine(x:1,y:1,z:0)
            addMine(x:1,y:2,z:0)
            addMine(x:1,y:3,z:0)
            addMine(x:4,y:6,z:0)
            addMine(x:4,y:7,z:0)
            addMine(x:5,y:6,z:0)
            addMine(x:5,y:7,z:0)
            addMine(x:6,y:6,z:0)
            addMine(x:6,y:7,z:0)
            addMine(x:5,y:0,z:0)
            addMine(x:5,y:1,z:0)
            addMine(x:6,y:0,z:0)
            addMine(x:6,y:1,z:0)
            addMine(x:7,y:0,z:0)
            addMine(x:7,y:1,z:0)
            state = State.Playing
            tap(x:5,y:3,z:7)
            tap(x:0,y:2,z:7)
            tap(x:5,y:3,z:0)
            tap(x:0,y:2,z:0)
            soundEnabled = true
            headerView.timerLbl.isHidden = true
            headerView.flagsLbl.text = String(numMines-flags)
            headerView.flagsLbl.sizeToFit()
        }
        if(boardType == 2) {
            soundEnabled = false
            randomization = false
            setNumMines(val: 0)
            addMine(x:0,y:0,z:7)
            addMine(x:0,y:5,z:7)
            addMine(x:1,y:7,z:7)
            addMine(x:3,y:7,z:7)
            addMine(x:4,y:3,z:7)
            addMine(x:6,y:4,z:7)
            addMine(x:7,y:3,z:7)
            addMine(x:7,y:0,z:7)
            addMine(x:7,y:3,z:7)
            addMine(x:7,y:4,z:7)
            addMine(x:7,y:7,z:7)

            addMine(x:0,y:0,z:0)
            addMine(x:0,y:5,z:0)
            addMine(x:1,y:7,z:0)
            addMine(x:3,y:7,z:0)
            addMine(x:4,y:3,z:0)
            addMine(x:6,y:4,z:0)
            addMine(x:7,y:3,z:0)
            addMine(x:7,y:0,z:0)
            addMine(x:7,y:3,z:0)
            addMine(x:7,y:4,z:0)
            addMine(x:7,y:7,z:0)
            
            addMine(x:0,y:0,z:0)
            addMine(x:0,y:0,z:5)
            addMine(x:0,y:1,z:7)
            addMine(x:0,y:3,z:7)
            addMine(x:0,y:4,z:3)
            addMine(x:0,y:6,z:4)
            addMine(x:0,y:7,z:3)
            addMine(x:0,y:7,z:0)
            addMine(x:0,y:7,z:3)
            addMine(x:0,y:7,z:4)
            addMine(x:0,y:7,z:7)

            addMine(x:7,y:0,z:0)
            addMine(x:7,y:0,z:5)
            addMine(x:7,y:1,z:7)
            addMine(x:7,y:3,z:7)
            addMine(x:7,y:4,z:3)
            addMine(x:7,y:6,z:4)
            addMine(x:7,y:7,z:3)
            addMine(x:7,y:7,z:0)
            addMine(x:7,y:7,z:3)
            addMine(x:7,y:7,z:4)
            addMine(x:7,y:7,z:7)

            addMine(x:0,y:0,z:0)
            addMine(x:0,y:0,z:5)
            addMine(x:1,y:0,z:7)
            addMine(x:3,y:0,z:7)
            addMine(x:4,y:0,z:3)
            addMine(x:6,y:0,z:4)
            addMine(x:7,y:0,z:3)
            addMine(x:7,y:0,z:0)
            addMine(x:7,y:0,z:3)
            addMine(x:7,y:0,z:4)
            addMine(x:7,y:0,z:7)
            
            addMine(x:0,y:7,z:0)
            addMine(x:0,y:7,z:5)
            addMine(x:1,y:7,z:7)
            addMine(x:3,y:7,z:7)
            addMine(x:4,y:7,z:3)
            addMine(x:6,y:7,z:4)
            addMine(x:7,y:7,z:3)
            addMine(x:7,y:7,z:0)
            addMine(x:7,y:7,z:3)
            addMine(x:7,y:7,z:4)
            addMine(x:7,y:7,z:7)
            
            state = State.Playing
            tap(x:3,y:1,z:7)
            tap(x:4,y:5,z:7)
            tap(x:3,y:1,z:0)
            tap(x:4,y:5,z:0)
            tap(x:0,y:3,z:1)
            tap(x:0,y:6,z:2)
            tap(x:7,y:3,z:1)
            tap(x:3,y:0,z:1)
            tap(x:3,y:7,z:1)
            tap(x:7,y:2,z:5)
            tap(x:7,y:7,z:6)
            tap(x:7,y:6,z:1)
            tap(x:7,y:5,z:1)
            tap(x:7,y:6,z:2)
            tap(x:7,y:5,z:2)
            soundEnabled = true
            headerView.timerLbl.isHidden = true
            headerView.flagsLbl.text = String(numMines-flags)
            headerView.flagsLbl.sizeToFit()
        }
        
    }
    public func initBoard(x: Int, y: Int, z: Int) {
        var val: Int = 0
        if(!randomization) {
            setBoard()
            state = State.Playing
            return
        }
        for _ in 0..<numMines {
            while true {
                val = Int(arc4random_uniform(UInt32(numHorizontalTiles * numVerticalTiles * numHeightTiles)))
                let (x_,y_,z_) = getXYZ(id: val)
                if(!isValid(x:x_,y:y_,z:z_)) {continue}
                if(data[val] == false && val != getId(x:x,y:y,z:z)) {break}
            }
            data[val] = true
        }
        state = State.Playing
    }
    

    
    public func countMinesXY(x: Int, y: Int, z: Int) -> Int {
        var numMines = 0
        for i in 0..<26 {
            if(isValid(x:x+dx[i],y:y+dy[i],z:z+dz[i]) && isMine(id: getId(x:x+dx[i],y:y+dy[i],z:z+dz[i]))) {numMines += 1}
        }
        return numMines
    }
    
    public func countFlagsXY(x: Int, y: Int, z: Int) -> Int {
        var numFlags = 0
        for i in 0..<26 {
            if(isValid(x:x+dx[i],y:y+dy[i],z:z+dz[i]) && isFlag(id:getId(x:x+dx[i],y:y+dy[i],z:z+dz[i]))) {numFlags += 1}
        }
        return numFlags
    }
    
    public func addMine(x: Int, y: Int, z: Int) {
        if(!isValid(x:x,y:y,z:z)) {return}
        let id=getId(x:x,y:y,z:z)
        if(!data[id]){
            data[id] = true
            numMines=numMines+1
        }
    }
    
    public func showTile(x: Int, y: Int, z: Int, tap:Bool) {
        let tileId = getId(x: x, y: y, z: z)
        let tile = tiles[tileId]
        if(tap) {
            if tile.state == .Discovered || tile.state == .Flagged || tile.state == .BadFlag || tile.state == .FlaggedMine {
                return
            }
            if isMine(id: tileId) {
                gameOver(id: tileId)
                return
            }
            let numMinesAround = countMinesXY(x: x, y: y, z: z)
            safe += 1
            tile.minesAround = numMinesAround
            tile.state = .Discovered
            scnScene.discovered(id: tileId)

            
            if numMinesAround == 0 {
                for i in 0..<26 {
                    if(isValid(x:x+dx[i],y:y+dy[i],z:z+dz[i])) {
                        showTile(x:x+dx[i],y:y+dy[i],z:z+dz[i],tap:true)
                    }
                }
            }
        } else {
            if tile.state != .Discovered {
                toggleFlag(x: x, y: y, z: z)
            }
        }
        if safe == numValidTiles - numMines && flags == numMines{
            won()
            return
        }
    }
    
    public func reset() {
        seconds = 0
        safe = 0
        flags = 0
        state = .Waiting
        //prevState = .Waiting
        hintX = -1
        hintY = -1
        hintZ = -1
        hintType = -1
        headerView.flagsLbl.text = String(numMines-flags)
        headerView.timerLbl.text = String(seconds)
        headerView.flagsLbl.sizeToFit()
        headerView.timerLbl.sizeToFit()
        timer.invalidate()
        for i in 0..<numTiles {
            if(randomization) {data[i] = false}
            tiles[i].state = .Empty
        }
        scnScene.restart()

    }
    
    public func toggleFlag(x: Int, y: Int, z: Int) {
        let tileId = getId(x: x, y: y, z: z)
        let tile = tiles[tileId]
        if tile.state == .Empty {
            tile.state = .Flagged
            flags += 1
            if(animationEnabled) {scnScene.addFlag(id:tileId)}
        } else if tile.state == .Flagged {
            tile.state = .Empty
            flags -= 1
            if(animationEnabled) {scnScene.removeFlag(id:tileId)}
        }
        playSound(sound:1 )
        headerView.flagsLbl.text = String(format: "%d", numMines-flags)
        headerView.sizeToFit()
    }
    
    public func setNumMines(val: Int) {
        if(state == .Playing) {restart()}
        numMines = val
        if(val < Int(headerView.slider.minimumValue)) {headerView.slider.minimumValue = Float(val)}
        headerView.slider.value = Float(numMines)
        headerView.slider.setValue(Float(numMines), animated: true)
        headerView.flagsLbl.text = String(numMines-flags)
        headerView.flagsLbl.sizeToFit()
    }
    public func status(x: Int, y: Int, z: Int) -> Int {
        let id=getId(x:x , y:y, z:z)
        if(tiles[id].state == .Discovered) {
            return SAFE
        } else if(tiles[id].state == .Flagged) {
            return MINE
        } else if(tiles[id].state == .ExplodedMine) {
            return EXPLODEDMINE
        } else {return UNKNOWN}
    }
    
    public func showMines(deadId: Int) {
        for i in 0..<tiles.count {
            if isMine(id: i) || isFlag(id: i) {
                if i == deadId {
                    tiles[i].state = .ExplodedMine
                } else if isMine(id: i) && isFlag(id: i) {
                    tiles[i].state = .FlaggedMine
                } else if isFlag(id: i) {
                    tiles[i].state = .BadFlag
                } else {
                    tiles[i].state = .Mine
                }
            }
        }
    }
    public func gameOver(id: Int) {
        showMines(deadId: id)
        if(animationEnabled) {
            scnScene.lost()
            headerView.setLostView()
        }

        timer.invalidate()
        state = State.GameOver
    }
    
    public func flag(x: Int, y: Int, z: Int) {
        longTap(x: x, y: y, z: z)
    }
    public func unflag(x: Int, y: Int, z: Int) {
        longTap(x: x, y: y, z: z)
    }
    
    
    public func play() {
        restart()
    }
    
    public func restart() {
        if(state != .Waiting) {
            reset()
            state = .Waiting
            setup()
        }
        
    }
    
}

