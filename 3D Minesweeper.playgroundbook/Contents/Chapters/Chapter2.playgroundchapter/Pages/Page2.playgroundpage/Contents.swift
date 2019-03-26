/*:
 # Exploring 3D Minesweeper Functions Part 2
 - flag(x:x, y:y, face:face) - flags the tile as a mine at position (x, y, face)
 - hint() - returns position (x,y,face) of the hint
 - variables numHorizontalTiles x numVerticalTiles x numHeightTiles are 8x8x8 the size of the minefield cube
 
 To learn the code fragments step through the code slowly and then at the end you can write your own code. While the code is running you can still explore the cube via pan, zoom or rotate.
 
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
setMineDensity(percentage: /*#-editable-code set mine density*/10/*#-end-editable-code*/)
sound(enabled: /*#-editable-code sound enabled*/true/*#-end-editable-code*/)
//#-code-completion(identifier, show, play, mines, tap, flag, hint, status, numHorizontalTiles, numVerticalTiles)

/*:
 # Flag a mine (or remove a flag):
 - flag(x: Int, y: Int) (if you flag the same location again, it will remove the flag)
 */
flag(x: /*#-editable-code set x */5/*#-end-editable-code*/,y: /*#-editable-code set y */5/*#-end-editable-code*/, face: .Green )
/* If you flag the same location again, it will remove the flag */
flag(x: /*#-editable-code set x */5/*#-end-editable-code*/,y: /*#-editable-code set y */5/*#-end-editable-code*/, face: .Green )

/*:
 # Hint from revealed constraints:
 - (x,y,face,type)=hint()
    - (x,y): Coordinates of the hint
    - type:
        - UNKNOWN (cannot be determined, ie no hints available)
        - MINE (determined to be a mine)
        - SAFE (determined to be safe)
    - face: [Face.Green,Face.Yellow,Face.Blue,Face.Red,Face.Purple,Face.Gray]
 */
var x,y,type: Int
var face: Face
(x,y,face,type)=hint()

/* We are iterating over the faces, tap on a coordinates and see if we can find hints */
var retStatus: Int
let faces = [Face.Green,Face.Yellow,Face.Blue,Face.Red,Face.Purple,Face.Gray]
for facevar:Face in faces {
    tap(x: /*#-editable-code set x*/5/*#-end-editable-code*/,y: /*#-editable-code set y*/5/*#-end-editable-code*/, face: facevar)
    retStatus=status(x: /*#-editable-code set x*/5/*#-end-editable-code*/,y: /*#-editable-code set y*/5/*#-end-editable-code*/,face: facevar)
    /* If the location on the face has a mine then you exploded it and need to restart */
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
//#-editable-code Tap to write your code
//#-end-editable-code
