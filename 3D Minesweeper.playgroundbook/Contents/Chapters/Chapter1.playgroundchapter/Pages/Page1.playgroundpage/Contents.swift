/*:
 # Introduction
 It is classic game of minesweeper with a 3D twist. Your goal is to uncover all the mines in the minefield of a cube size 8x8x8 without landing on a mine. Since its in 3D, you have to be aware of mine constraints not only on the faces, but between faces, at edges and corners.
 - Note:
- Pan, zoom and rotate the cube first to see the different faces. Then you can start the game by touching a tile.
- When a tile is tapped lightly, it will uncover the tile you touch. If the tile contains a mine, you will lose the game. If no mine is revealed, a number is displayed in the tile, indicating the number of adjacent mines; if there no adjacent neighboring mines, all adjacent tiles will be recursively revealed. The number on a revealed tile can be used logically deduce as a constraint whether the neighboring tiles are mines or safe tiles.
- When a tile is long tapped it will flag the tile as a mine. If you tap the tile again, it will remove the flag.
- To get a hint, press the yellow bulb on the top right. A red hint indicate its a mine and a green hint will indicate it is safe.
- Change the number of mines by using the slider on the top.
- Restart the game by pressing the green restart button on the top left.
- There is timer counter on the left and number of unflagged mines on the right.
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

