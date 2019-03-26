// LiveView.swift
// Minesweeper
// Created by Anav Mehta 3/18/2019
// Copyright (c) 2019 Anav Mehta. All rights reserved
import UIKit
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
var minesweeperBoard1: MinesweeperBoard1 = MinesweeperBoard1()
PlaygroundPage.current.liveView = minesweeperBoard1
minesweeperBoard1.setup()



