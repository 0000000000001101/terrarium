Priority:



* Fix the sizing issue. When the assets are dragged on screen, they are squashed around. Set the sizes in relation to the aspect ratios of the original images, not the split-size set in the inventory to split the vbox width among two asset images.



* Normalize the coordinate system. I think I'll set the size of one square to be the size of min(viewport width, viewport height). The normalized coordinates are what will be sent to the server, but the immediate positioning of the assets will of course be in pixels.

&#x20;   Ideas and issues:

&#x09;- Set the positions in percentage relation to the top left corner. Example, image 1 spawns at (50%, 50%) and image 2 spawns at (25%, 25%). The issue with this is that the images will spawn in relation to the screen size, but aspect ratios will make is such that the images will not spawn in relation to each other. For example, image 1 at 50%x might spawn overlapping with image2 at 25%x if image 2 is very wide and the screen is very narrow.

* As a follow-up, I'll need to add some way for the user to scroll around left-right and up-down. If possible, I would like for the user to be able to scroll around with the mouse wheel. (I don't know if I'll take mobile into consideration here for now).



* Start networking. Set up a connection to the server such that the client sends updated information to the server every time a deployed\_asset is moved (specifically every time the image is dropped after being dragged).

&#x20;       Eventually I will need to get information from the server upon loading the scene for the first time to load in the deployed\_assets.

  * Find another way to turn the data into a string. Right now JSON alphabetizes the array. I don't know if this is an issue or not, though.



* Add a theme! Make it pretty :)

  * Make the theme pixel offsets in relation to the viewport size



* (It may be fixed?) There is a weird bug when it comes to hiding/showing the radial menu when images are spam moved/clicked on in quick succession where every subsequent click will hide/show the menu such that it cannot be hidden again unless it is moved or another asset is clicked. This does not seem to be a huge hinderance, however.



* Have the draggable from the inventory be displayed above the inventory. (Layer or z layer property?)



* Have the wheel spawn in relation to the image aspect ratio.



* Allow the assets to be resized on the canvas
* Allow the layering of the assets be changed around.
* Make a description pop-up when the description button is pressed.
* Rename functionality?



Future goals:



* Background selector?

