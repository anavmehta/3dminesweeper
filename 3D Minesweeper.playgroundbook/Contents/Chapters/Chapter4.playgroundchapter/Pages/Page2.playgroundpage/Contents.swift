/*:
 # Solving The Minefield Part 2
 This is similar to the earlier page, but here we try a different heuristic by trying to guess in the middle instead of the edges. Does this have better chance of winning the game? Step through the code to understand how the algorithm works, then play, and change the code to improve it.
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
/* A function to smartly guess */
func guess() -> Bool {
    var found: Bool = false
    var lost: Bool = false
    /* Try the interiors, they have the best chance of giving us better constraints */
    for x in numHorizontalTiles/4..<3*numHorizontalTiles/4 {
        for y in numVerticalTiles/4..<3*numVerticalTiles/4 {
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
    /* If we didnt find anything in the center, then we have to do the entire minefield */
    if(!(lost || found)) {
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
    }
    return !lost
}
play()
while(true) {
    /* Lets find out the number of mines in minefield */
    num_mines = mines()
    /* Lets fine out if we can solve any constraints (via hint) */
    (x, y, face, type) = hint()
    /* If the number of mines in the field is 0 and the rest of mines are safe,
       we are done. We should exit the loop */
    if(num_mines == 0 && type == UNKNOWN) {break;}
    
    if(type == SAFE) { /* If the solver gives back a safe mine, we can safely expose it */
        tap(x:x, y:y,face:face)
    } else if (type == MINE) { /* IF the solver gives us a location of a mine, flag it */
        flag(x:x, y:y,face:face)
    } else { /* Else we have no choice but to guess, but we can be smart about it */
        /* If our guess was not successful we exit the loop */
        if(!guess()) {break;}
    }
}
//#-end-editable-code

