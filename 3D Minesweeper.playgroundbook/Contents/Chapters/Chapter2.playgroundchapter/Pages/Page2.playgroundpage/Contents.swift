/*:
 # Exploring 3D Minesweeper Functions Part 2
 - flag(x:x, y:y, face:face) - flags the tile as a mine at position (x, y, face)
 - hint() - returns position (x,y,face) of the hint
 - variables numHorizontalTiles and numVerticalTiles and numHeightTiles is the size of the minefield
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
setMineDensity(percentage: /*#-editable-code set mine density*/50/*#-end-editable-code*/)
sound(enabled: /*#-editable-code sound enabled*/false/*#-end-editable-code*/)
//#-editable-code
//#-code-completion(identifier, show, play, mines, tap, flag, hint, status, numHorizontalTiles, numVerticalTiles)
/*:
 - Example: *How to find a hint (which can be determined from the revealed tiles*:
  * (x,y,face,type)=hint()
  * type:
       * UNKNOWN (not yet explored)
       * MINE (can be determined to be a mine)
       * SAFE (can be determined to be safe)
 */
var x,y,type: Int
var face: Face
(x,y,face,type)=hint()
//#-editable-code Tap to write your code
//#-end-editable-code
/*:
 - Example: *How to flag a mine (this can be done on the liverview by long tapping the tile*:
 * flag(x: Int, y: Int)
 * (if you flag the same location again, it will remove the flag)
 */
flag(x: /*#-editable-code set x */5/*#-end-editable-code*/,y: /*#-editable-code set y */5/*#-end-editable-code*/, face: .Green )
/* If you flag the same location again, it will remove the flag */
flag(x: /*#-editable-code set x */5/*#-end-editable-code*/,y: /*#-editable-code set y */5/*#-end-editable-code*/, face: .Green )
//#-editable-code Tap to write your code
// We are iterating over the faces, tap on a coordinates and see if we can find hints
var retStatus: Int
let faces = [Face.Green,Face.Yellow,Face.Blue,Face.Red,Face.Purple,Face.Gray]
for facevar:Face in faces {
    tap(x: /*#-editable-code set x*/5/*#-end-editable-code*/,y: /*#-editable-code set y*/5/*#-end-editable-code*/, face: facevar)
    retStatus=status(x: /*#-editable-code set x*/5/*#-end-editable-code*/,y: /*#-editable-code set y*/5/*#-end-editable-code*/,face: facevar)
    // If the location on the face has a mine then you exploded it and need to restart
    if(retStatus == EXPLODEDMINE) {play()}
    else {
        (x,y,face,type) = hint()
        if(type == SAFE) {
            tap(x:x,y:y,face:face)
        } else if (type == MINE) {
            flag(x:x, y:y, face:face)
        }
    }
}
//#-end-editable-code
//#-hidden-code
//#-end-hidden-code
