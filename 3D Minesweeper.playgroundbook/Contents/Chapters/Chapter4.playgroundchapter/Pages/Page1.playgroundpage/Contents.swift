/*:
 # Solving The Minefield Part 1
Using the functions, we will try to play the 3d minefield game through the Swift Playground. We use the powerful constraint solver (hint()) routine. When there isnt enough data to solve the constraints, we will guess by going to the first unopened mine from the origin of the every face. But there might be a better way? Step through the code to understand how the algorithm works, then play, and change the code to improve it.
 
  [Next Page](@next)
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
/* Since we know how to solve constraints, the trick is how to succesfully guess. In this case we select the first unopened mine from the origin of the face */
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
/* Start the game */
play()
while(true) {
    /* Lets find out the number of mines in minefield */
    num_mines = mines()
    /* Lets fine out if we can solve any constraints (via hint) */
    (x, y, face, type) = hint()
    /* If number of mines in the field is zero and no safe mines can be found. We have won. We can exit the loop */
    if(num_mines == 0 && type == UNKNOWN) {break;}
    if(type == SAFE) {
        tap(x:x, y:y, face:face)
    } else if (type == MINE) {
        flag(x:x, y:y, face:face)
    } else { /* Else we have no choice but to guess, but we can be smart about it */
        /* If our guess was not successful we exit the loop */
        if(!guess()) {break;}
    }
}
//#-end-editable-code
