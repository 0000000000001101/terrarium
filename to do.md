MVP:



* The inventory also has some resizing issues. When you go to and from full-screen, it bugs out a bit. The plant assets also have a weird bug where they wont resize to the full width of the scroll container when making the screen smaller than the default (while the animals' do). This is not the biggest issue, though.



* Normalize the coordinate system. I think I'll set the size of one square to be the size of min(viewport width, viewport height). The normalized coordinates are what will be sent to the server, but the immediate positioning of the assets will of course be in pixels.

&#x20;   Ideas and issues:

&#x09;- Set the positions in percentage relation to the top left corner. Example, image 1 spawns at (50%, 50%) and image 2 spawns at (25%, 25%). The issue with this is that the images will spawn in relation to the screen size, but aspect ratios will make is such that the images will not spawn in relation to each other. For example, image 1 at 50%x might spawn overlapping with image2 at 25%x if image 2 is very wide and the screen is very narrow.

* As a follow-up, I'll need to add some way for the user to scroll around left-right and up-down. If possible, I would like for the user to be able to scroll around with the mouse wheel. (I don't know if I'll take mobile into consideration here for now).



* Start networking. Set up a connection to the server such that the client sends updated information to the server every time a deployed\_asset is moved (specifically every time the image is dropped after being dragged).

&#x20;       Eventually I will need to get information from the server upon loading the scene for the first time to load in the deployed\_assets.

  * Find another way to turn the data into a string. Right now JSON alphabetizes the array. I don't know if this is an issue or not, though.



* Add a theme! Make it pretty :)

  * Make the theme pixel offsets in relation to the viewport size



* Have the draggable from the inventory be displayed above the inventory. (Layer or z layer property?)



* Have the wheel spawn in relation to the image aspect ratio.



* Change the size of the resize menu when the asset is resized
* Allow the layering of the assets be changed around.

  * Add asset names so that 

    * Add rename functionality?
* Make a description pop-up when the description button is pressed.



* Allow the inventory to be hidden and re-shown. Spawn a button whose center is halfway down the inventory on the right side of the inventory whose texture arrow direction changes depending on the visibility status of the inventory.



* Fix the bug that happens where the menus hide weirdly or get repositioned when i drag the asset quickly and the menus quickly hide and reshow.
* The radial menu also does not follow the image to a T when it's resized.



Future goals:



* Background selector?

