/*: #Exploring Mine Density
 Lets try setting the mine density programmatically to low and see if you can complete the game. If you need help you can press the Yellow bulb button on the top right
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
//#-hidden-code
//#-end-hidden-code
