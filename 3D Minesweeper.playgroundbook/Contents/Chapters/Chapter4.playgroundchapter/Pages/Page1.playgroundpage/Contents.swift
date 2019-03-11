/*: # Programming Part 1
Using what we have learned. We will try to uncover the minefield programmatically. We use the powerful constraint solver (hint()) routine. One such code is given below. There is some luck in minefield, especially when you cant solve the constraints. You have to guess when those visible constraints cannot give you the location of a minefield
 */
//#-hidden-code
import PlaygroundSupport
import Foundation
PlaygroundListener.shared.setup()
//#-end-hidden-code
//#-editable-code
var x, y, type, num_mines: Int
var face: Face
sound(enabled: false)
animation(enabled: true)
setMineDensity(percentage:10)
let faces = [Face.Green,Face.Yellow,Face.Blue,Face.Red,Face.Purple,Face.Gray]
/* Since we know how to solve constraints, the trick is how to succesfully guess */
func guess() -> Bool {
    var found: Bool = false
    var lost: Bool = false
    found = false
    for x in 1..<numHorizontalTiles+1 {
        for y in 1..<numVerticalTiles+1 {
            for face:Face in faces {
                if(status(x:x,y:y,face:face) == UNKNOWN) {
                    tap(x:x,y:y,face:face)
                    if(status(x:x,y:y,face:face) == EXPLODEDMINE) {
                        print("You lost")
                        lost = true
                    } else {
                        found = true
                    }
                    if(lost || found) {break}
                }
            }
            if(lost || found) {break}
        }
        if(lost || found) {break}
    }
    return !lost
}
play()
while(true) {
    num_mines = mines()
    (x, y, face, type) = hint()
    if(num_mines == 0 && type == UNKNOWN) {break;}
    if(type == SAFE) {
        tap(x:x, y:y, face:face)
    } else if (type == MINE) {
        flag(x:x, y:y, face:face)
    } else {
        /* If our guess was not successful we exit the loop */
        if(!guess()) {break;}
    }
}
//#-end-editable-code
//#-hidden-code
//#-end-hidden-code
