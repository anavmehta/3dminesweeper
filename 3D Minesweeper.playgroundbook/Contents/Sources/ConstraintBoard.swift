// Common.swift
// Minesweeper
// Created by Anav Mehta 2/8/2019
// Copyright (c) 2019 Anav Mehta. All rights reserved
import Foundation
import PlaygroundSupport
import UIKit
import CoreGraphics

public class MinesweeperBoard1 : ViewController {
    public func setup() {
        headerView.sliderEnabled = false
        gameSceneView.reset()
        headerView.slider.removeFromSuperview()
        gameSceneView.boardType = 1
        gameSceneView.setBoard()
        return
    }
}

public class MinesweeperBoard2 : ViewController {
    public func setup() {
        headerView.sliderEnabled = false
        gameSceneView.reset()
        headerView.slider.removeFromSuperview()
        gameSceneView.boardType = 2
        gameSceneView.setBoard()
        return
    }
}
