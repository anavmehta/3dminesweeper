// HeaderView.swift
// Minesweeper
// Created by Anav Mehta 3/18/2019
// Copyright (c) 2019 Anav Mehta. All rights reserved
import Foundation
import UIKit
import SceneKit
import AVFoundation
import PlaygroundSupport

public class HeaderView: UIView {

    init() {
        super.init(frame: .zero)
        initialize()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    

    public let restartImg = UIImage(named: "iconfinder_Power_-_Restart_99892")
    public let hintImg = UIImage(named: "iconfinder_bulb_1511312")
    
    public var restartButton: UIButton! = UIButton(frame: CGRect(x: 0, y: 0, width:size, height:size))
    public var hintButton: UIButton! = UIButton(frame: CGRect(x: 0, y: 0, width:size, height:size))
    public var hintView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: size-10, height: size-10))
    public var noHintView: UILabel = UILabel(frame: CGRect(x: 0, y:0, width:2*size, height: size/2))
    public var winView: UILabel = UILabel(frame: CGRect(x: 0, y:0, width:12*size, height: 5*size))
    public var lostView: UILabel = UILabel(frame: CGRect(x: 0, y:0, width:12*size, height: 3*size))
    
    public var flagsLbl: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: size, height: size))
    public var timerLbl: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: size*2, height: size))
    public var slider: UISlider = UISlider(frame: CGRect(x: 0, y: 0, width: 100, height: size))
 
    public var sliderEnabled: Bool = true

    
    var cxt: CGContext!
    
    
    
    
    
    func initialize() {
        //gameSceneView = viewControllerGameScene?.gameSceneView
        self.translatesAutoresizingMaskIntoConstraints = false
        restartButton.setImage(restartImg, for: .normal)
        restartButton.setTitle("*", for: .normal)
        restartButton.setTitleColor(UIColor.green, for: .normal)
        restartButton.addTarget(self, action: #selector(pressed(sender:)), for: .touchUpInside)
        
        hintButton.setImage(hintImg, for: .normal)
        hintButton.setTitle("?", for: .normal)
        hintButton.setTitleColor(UIColor.green, for: .normal)
        hintButton.addTarget(self, action: #selector(hinted(sender:)), for: .touchUpInside)
        
        slider.minimumValue = 1
        slider.maximumValue = Float(maxMines)
        slider.setValue(Float(gameSceneView.numMines), animated: true)
        slider.value = Float(gameSceneView.numMines)
        slider.minimumTrackTintColor = .green
        slider.maximumTrackTintColor = .red
        slider.addTarget(self, action: #selector(changeValue(_:)), for: .valueChanged)
        slider.center = CGPoint(x: width/2, y:size/2)
        
      
        flagsLbl.text = String(gameSceneView.numMines-gameSceneView.flags)
        flagsLbl.textColor = .black
        flagsLbl.font =  UIFont(name: "Arial", size: 30)!
        flagsLbl.textAlignment = .center
        flagsLbl.sizeToFit()
        flagsLbl.center = CGPoint(x: width-125, y: size/2)
        
        
        timerLbl.text = String(gameSceneView.seconds)
        timerLbl.textColor = .black
        timerLbl.font =  UIFont(name: "Arial", size: 30)!
        timerLbl.textAlignment = .center
        timerLbl.sizeToFit()
        timerLbl.center = CGPoint(x: 125, y: size/2)
        
        
        hintButton.center = CGPoint(x: width-size/2, y:size/2)
        restartButton.center = CGPoint(x: 0+size/2, y:size/2)
        noHintView.center = CGPoint(x:430, y:40)
        noHintView.backgroundColor = .yellow
        noHintView.textColor = .black
        noHintView.isHidden = true
        noHintView.font =  UIFont(name: "Arial", size: 10)!
        noHintView.textAlignment = .center
        noHintView.text = "No hints available"
        self.addSubview(noHintView)
        winView.center = CGPoint(x:270, y:200)
        winView.backgroundColor = .orange
        winView.textColor = .black
        winView.isHidden = true
        winView.text = "Congratulations you won!"
        winView.font = UIFont(name: "Arial", size: 40)!
        winView.sizeToFit()
        winView.textAlignment = .center
        self.addSubview(winView)
        lostView.center = CGPoint(x:320, y:200)
        lostView.backgroundColor = .red
        lostView.textColor = .white
        lostView.isHidden = true
        lostView.text = "Sorry you lost!"
        lostView.font = UIFont(name: "Arial", size: 40)!
        lostView.sizeToFit()
        lostView.textAlignment = .center
        self.addSubview(lostView)
        self.addSubview(slider)
        self.addSubview(flagsLbl)
        self.addSubview(timerLbl)
        self.addSubview(restartButton)
        self.addSubview(hintButton)
        gameSceneView.initialize()

    }
    
    
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect);
        
        UIColor.gray.setFill()
        UIRectFill(rect)
        flagsLbl.text = String(gameSceneView.numMines-gameSceneView.flags)
        timerLbl.text = String(gameSceneView.seconds)
        if(gameSceneView.numMines < Int(slider.minimumValue)) {slider.minimumValue = Float(gameSceneView.numMines)}
        slider.value = Float(gameSceneView.numMines)
        slider.setValue(Float(gameSceneView.numMines), animated: true)
        
        cxt = UIGraphicsGetCurrentContext()
    }
    

    func setNoHintView() {
        noHintView.isHidden = false
        noHintView.transform = CGAffineTransform(scaleX: 0, y: 0)
        if(gameSceneView.animationEnabled) {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.noHintView.transform = .identity
            }, completion: nil)
            setNeedsDisplay(CGRect(x: 0, y: 0, width: 768, height: 1024))
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.noHintView.isHidden = true
            }
        } else {
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                self.noHintView.transform = .identity
            }, completion: nil)
            setNeedsDisplay(CGRect(x: 0, y: 0, width: 768, height: 1024))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.noHintView.isHidden = true
            }
        }
        
        setNeedsDisplay(CGRect(x: 0, y: 0, width: 768, height: 1024))
    }
    func clearViews() {
        noHintView.isHidden = true
        winView.isHidden = true
        lostView.isHidden = true
    }
    
    
    @objc public func hinted(sender: UIButton!) {
        gameSceneView.hintX = -1
        gameSceneView.hintY = -1
        gameSceneView.hintZ = -1
        gameSceneView.hintType = -1
        if(gameSceneView.state != .Playing) {
            setNoHintView()
            gameSceneView.playSound(sound: 5)
            return
        }
        let (_,_,_,_) = gameSceneView.hint()
        scnScene.hint()
        if(gameSceneView.hintType != UNKNOWN) {gameSceneView.playSound(sound: 3)}
        else {
            gameSceneView.playSound(sound :5)
            setNoHintView()
        }
    }
    
    

    public func setMineDensity(percentage: Int){
        if(gameSceneView.state == .Playing) {gameSceneView.restart()}
        gameSceneView.numMines = (maxMines)*percentage/100
        slider.value = Float(gameSceneView.numMines)
        slider.setValue(Float(gameSceneView.numMines), animated: true)
        flagsLbl.text = String(gameSceneView.numMines-gameSceneView.flags)
        flagsLbl.sizeToFit()
        setNeedsDisplay(CGRect(x: 0, y: 0, width: 768, height: 1024))
    }

    
    func setWinView() {
        winView.isHidden = false
        winView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.winView.transform = .identity
        }, completion: nil)
        setNeedsDisplay(CGRect(x: 0, y: 0, width: 768, height: 1024))
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.winView.isHidden = true
        }
        timer.invalidate()
        setNeedsDisplay(CGRect(x: 0, y: 0, width: 768, height: 1024))
    }
    func setLostView() {
        lostView.isHidden = false
        lostView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.lostView.transform = .identity
        }, completion: nil)
        setNeedsDisplay(CGRect(x: 0, y: 0, width: 768, height: 1024))
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.lostView.isHidden = true
        }
        setNeedsDisplay(CGRect(x: 0, y: 0, width: 768, height: 1024))
    }
   
    
    @objc public func changeValue(_ sender: UISlider) {
        gameSceneView.numMines = Int(sender.value)
        gameSceneView.restart()
        //gameSceneView.state = .Waiting
        flagsLbl.text = String(gameSceneView.numMines-gameSceneView.flags)
        flagsLbl.sizeToFit()
        setNeedsDisplay(CGRect(x: 0, y: 0, width: 768, height: 1024))
        
    }
    
    @objc public func pressed(sender: UIButton!) {
        gameSceneView.restart()
        setNeedsDisplay(CGRect(x: 0, y: 0, width: 768, height: 1024))
        
    }
    
    
}

