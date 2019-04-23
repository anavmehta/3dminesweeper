# 3dminesweeper
A unique 3d minesweeper playground app, built with Scenekit, Avkit
A 3D minesweeper, a unique rendition of the well known minesweeper was developed in Swift playground using innovative usages of SceneKit. It uses Playgroundbook as chapters and pages and introduces features in each chapter via a cutscene. Attributions for each sounds and images assets used are in the Comments section.

The following are features available in the live view

    On the menu bar from left to right, a green restart button, a timer counter, a mine count slider, a remaining mine counter and a yellow bulb hint button.

    8x8x8 minesweeper cube with surface mines explored via pan, zoom, rotation and touch.

    A short tap opens the tile if it is empty or the user loses if it has a mine. If the neighboring tiles are empty, the minefield is recursively revealed or the number of neighboring mines is shown in the tile (Its 3d space, watch for edges and corners).

    A long tap marks a tile as a mine with a flag. Clicking it again will remove the flag.

    Pressing the hint, reveals it, if it can be deduced from the current state. A red sphere is placed if the hint tile has a mine, while a green sphere is placed if the hint tile is safe. 

    If all tiles are marked with flags (# unflagged mines = 0) or opened, the user wins.

The following features are available in the playground.

    Ch1 features the live view while adjusting the mine count.
 
    Ch2 introduces functions - status, hint, tap, flag, mines, setMineDensity, sound, animation and the face coordinate system (shown as “o” in its origin tile)  used to manipulate the live view from the playground. 

    Ch3 explores hint(), the powerful constraint solver.

    Ch4 plays the minefield using functions in Swift Playground.

In this app, a novel constraint solver and SceneKit, UIKit, and AVKit features were implemented.

    A constraint solver with a unique backtracking algorithm to detect hints, also a function used in the playground to solve the minefield

    UIView and ViewController 
 
        Arranging views using constraints

        Creating labels buttons, sliders, and call backs

    Asynchronous Playground Communication with Live View

        Eight functions can be used in the playground. The function and parameters are packaged into strings and unpackaged in live view and command executed, and in case of a expected response, a value is sent back to the playground.  

    SceneKit

        Creating a scene programmatically with camera nodes and lighting and a set of scene nodes, which included geometries 8x8x8 cube, spheres, texts, materials for faces, flags and poles, textures and colors 

       Transformation and focus of camera on the hint when revealed.

       Special cases of marking of the surface of same nodes visible to user (on edges and corners)

       Animation for hints, and winning and losing scenes

           Hints (slow blinking)

           Partical setup to create fireworks (Fireparticles.scnp)

           Physics and gravity manipulation for fireworks and explosion

    Hype Tumult to a cutscene with a video showcasing each chapter.

    Markup for playground used for quick help 

    AVKit for sounds for various events (hints, loss, win, safe..). 
