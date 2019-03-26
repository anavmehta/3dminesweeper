/*:
 # Exploring Mine Density
 Lets try setting the mine density to low and see if you can complete the game.
 If you need help you can press the Yellow bulb button on the top right
 - If an hint can be deduced from the minefield state it will be revealed as
   - A red sphere indicating the hint tile as a mine (tapping the tile will flag it)
   - A green sphere indicating the hint tile as safe (tapping the tile will open it)
 - Otherwise it will indicate that there are "No hints available" and you need to take a guess
 
 [Next Page](@next)
*/

//#-hidden-code
import PlaygroundSupport
import Foundation
import SceneKit
PlaygroundListener.shared.setup()
//#-end-hidden-code

//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, true, false)
setMineDensity(percentage: /*#-editable-code set mine density*/10/*#-end-editable-code*/)
play()

