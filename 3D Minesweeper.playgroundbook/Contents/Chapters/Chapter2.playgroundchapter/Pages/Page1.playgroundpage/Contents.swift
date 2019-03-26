/*:
 # Exploring 3D Minesweeper Functions, Part 1
 - play() - starts the game
 - setMineDensity(percentage: Int) - sets the density of the minefield (0 to 100)
 - sound(enabled: Bool) - enables or disables the sound
 - tap(x:x, y:y, face:face) - reveals the tile at position (x, y,face)
 - mines() - number of mines currenly in the game
 - status(x:Int:,y:Int,face:face) - returns the status of the tile at position (x,y,face)
 
 To learn the code fragments step through the code slowly and then at the end you can write your own code. While the code is running you can still zoom, pan and rotate and explore the cube.
 
  [Next Page](@next)
 */
//#-hidden-code
import PlaygroundSupport
import Foundation
PlaygroundListener.shared.setup()
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, true, false)
play()
setMineDensity(percentage: /*#-editable-code set mine density*/10/*#-end-editable-code*/)
sound(enabled: /*#-editable-code sound enabled*/true/*#-end-editable-code*/)
//#-code-completion(identifier, show, play, mines, tap, flag, hint, status, numHorizontalTiles, numVerticalTiles)
/*:
 # Find the number of mines in the minefield:
 - numMines=mines() (number of mines in the minefield)
 */
var numMines: Int
numMines = mines()
/*: Before we start the rest of the commands lets find out about our coordinate system. The little black circle at each face is tile (1,1) of that face. The x and y axist of the face is at that location. So if you look at the Green face at the black circle is at the bottom left, thats tile (1,1) and the coordinate of the top right is (8,8). Now lets explore how to get the status of each mine programmatically so we can build a program to automatically solve this minefield
 */
//#-code-completion(identifier, show, play, mines, tap, flag, hint, status, numHorizontalTiles, numVerticalTiles)
/*:
 # Tap a tile:
 - tap(x: Int, y: Int, face: Face)
    - x and y are coordinates ranging from 1 to 8 and area relative to each face origin (1,1) denoted by "o" on each face
    - face: [Face.Green,Face.Yellow,Face.Blue,Face.Red,Face.Purple,Face.Gray]
 */
//#-code-completion(identifier, show, play, mines, tap, flag, hint, status, numHorizontalTiles, numVerticalTiles)
/*:
 # Status of a tile:
 - retStatus=status(x: Int, y: Int, face: Face)
    - retStatus (return status)
        - UNKNOWN (not yet explored)
        - FLAGGEDMINE (flagged a mine)
        - SAFE (tapped and safe)
        - EXPLODEDMINE (tapped and its a mine)
 */
var retStatus: Int
let faces = [Face.Green,Face.Yellow,Face.Blue,Face.Red,Face.Purple,Face.Gray]
for face:Face in faces {
    tap(x: /*#-editable-code set x*/5/*#-end-editable-code*/,y: /*#-editable-code set y*/5/*#-end-editable-code*/, face: face)
    retStatus=status(x: /*#-editable-code set x*/5/*#-end-editable-code*/,y: /*#-editable-code set y*/5/*#-end-editable-code*/,face: face)
    // If you exploded a mine you need to restart
    if(retStatus == EXPLODEDMINE) {play()}
}
//#-editable-code Tap to write your code
//#-end-editable-code
