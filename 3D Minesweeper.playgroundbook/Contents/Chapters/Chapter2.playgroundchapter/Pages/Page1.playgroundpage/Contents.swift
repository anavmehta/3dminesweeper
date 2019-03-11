/*:
 # Exploring 3D Minesweeper Functions, Part 1
 - play() - starts the game
 - setMineDensity(percentage: Int) - sets the density of the minefield
 - sound(enabled: Bool) - enables or disables the sound
 - tap(x:x, y:y, face:face) - reveals the tile at position (x, y,face)
 - mines() - returns the number of mines currenly in the game
 - status(x:Int:,y:Int,face:face) - returns the status of the tile at position (x,y,face)
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
setMineDensity(percentage: /*#-editable-code set mine density*/20/*#-end-editable-code*/)
sound(enabled: /*#-editable-code sound enabled*/true/*#-end-editable-code*/)
//#-code-completion(identifier, show, play, mines, tap, flag, hint, status, numHorizontalTiles, numVerticalTiles)
/*:
 - Example: *How to find the number of mines*:
 * numMines=mines()
 * numMines (number of mines in the minefield)
 */
//#-editable-code
var numMines: Int
numMines = mines()
/*: Before we start the rest of the commands lets find out about our coordinate system. The little black circle at each face is tile (1,1) of that face. The x and y axist of the face is at that location. So if you look at the Green face at the black circle is at the bottom left, thats tile (1,1) and the coordinate of the top right is (8,8). Now lets explore how to get the status of each mine programmatically so we can build a program to automatically solve this minefield
 */
//#-code-completion(identifier, show, play, mines, tap, flag, hint, status, numHorizontalTiles, numVerticalTiles)
/*:
 - Example: *How to find the status of a tile*:
 * tap(x: Int, y: Int, face: Face)
 * where x and y are coordinates relative to each Face
 * Face = {.Green, .Yellow, .Blue, .Red, .Purple, .White}
 */
//#-code-completion(identifier, show, play, mines, tap, flag, hint, status, numHorizontalTiles, numVerticalTiles)
/*:
 - Example: *How to find the status of a tile*:
 * retStatus=status(x: Int, y: Int, face: Face)
 * retStatus
 * UNKNOWN (not yet explored)
 * FLAGGEDMINE (flagged a mine)
 * SAFE (explored and is safe)
 * EXPLODEDMINE (the mine was explored and it is a mine)
 */
var retStatus: Int
let faces = [Face.Green,Face.Yellow,Face.Blue,Face.Red,Face.Purple,Face.Gray]
for face:Face in faces {
    tap(x: /*#-editable-code set x*/5/*#-end-editable-code*/,y: /*#-editable-code set y*/5/*#-end-editable-code*/, face: face)
    retStatus=status(x: /*#-editable-code set x*/5/*#-end-editable-code*/,y: /*#-editable-code set y*/5/*#-end-editable-code*/,face: face)
    // If the location on the face has a mine then you exploded it and need to restart
    if(retStatus == EXPLODEDMINE) {play()}
}
//#-editable-code Tap to write your code
//#-end-editable-code
//#-hidden-code
//#-end-hidden-code
