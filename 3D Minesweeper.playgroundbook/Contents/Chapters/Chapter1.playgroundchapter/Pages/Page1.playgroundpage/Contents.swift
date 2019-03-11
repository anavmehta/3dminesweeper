/*: # Introduction
 It is classic game of minesweeper with a few twists. You are a minesweeper and your goal is to uncover all the mines in the minefield of a cube size 8x8 without landing on a mine. You have to be aware of mines not only on the faces, but diagonally between faces. Turn the volume up. Stay safe and have fun! 😊
 - Note:
- When a tile is pressed lightly, it will uncover the tile you touch. If a tile containing a mine is revealed, you will lose the game. If no mine is revealed, a number is displayed in the tile, indicating the number of adjacent mines; if no mines are adjacent, the tile becomes blank, and all adjacent tiles will be recursively revealed.
- When a tile is long pressed it will flag the tile as a mine. Using the number on a revealed tile you can logically deduce whether the neighboring tiles are mines or safe tiles.
- To get a hint press the yellow bulb on the top right. A red hint indicate its a mine and a green hint will indicate it is safe. Later we will explore in detail how to do this systematically. 
- To change the number of mines use the slider button on the top.
 - You can restart the game by pressing the green restart button on the top left
 Enjoy! 😊
 [Next Page](@next)
 */
//#-hidden-code
import PlaygroundSupport
import Foundation
import SceneKit
PlaygroundListener.shared.setup()
//#-end-hidden-code
//#-editable-code
play()
//#-end-editable-code
//#-hidden-code
//#-end-hidden-code
