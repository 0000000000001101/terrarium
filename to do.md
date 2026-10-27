Priority:



* Fix the sizing issue. When the assets are dragged on screen, they are squashed around. Set the sizes in relation to the aspect ratios of the original images, not the split-size set in the inventory to split the vbox width among two asset images.



* Normalize the coordinate system. I think I'll set the size of one square to be the size of min(viewport width, viewport height). The normalized coordinates are what will be sent to the server, but the immediate positioning of the assets will of course be in pixels.

&#x20;   Ideas and issues:

&#x09;- Set the positions in percentage relation to the top left corner. Example, image 1 spawns at (50%, 50%) and image 2 spawns at (25%, 25%). The issue with this is that the images will spawn in relation to the screen size, but aspect ratios will make is such that the images will not spawn in relation to each other. For example, image 1 at 50%x might spawn overlapping with image2 at 25%x if image 2 is very wide and the screen is very narrow.

* As a follow-up, I'll need to add some way for the user to scroll around left-right and up-down. If possible, I would like for the user to be able to scroll around with the mouse wheel. (I don't know if I'll take mobile into consideration here for now).



* Fix positioning of the deployed\_assets when they are dragged onto the canvas. The x values are more or less fine, +/- a few pixels. The y values have issues though because I'm dividing the viewport height by the ceil(index/2), which causes issues when the total index count > 6.



* Start networking. Set up a connection to the server such that the client sends updated information to the server every time a deployed\_asset is moved (specifically every time the image is dropped after being dragged).

&#x20;       Eventually I will need to get information from the server upon loading the scene for the first time to load in the deployed\_assets.



* Allow the assets to be resized on the canvas.

  * Send packet to server upon resize
* Allow the assets to be deleted on the canvas.

  * Send packet to server upon deletion



* Add a theme! Make it pretty







Future goals:

