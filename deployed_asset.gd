class_name DeployedAsset
extends TextureRect

var hash_chars := "0123456789abcdef"

var asset_selected := false
var asset_dragging := false
var delay = 5

var difference_x
var difference_y

# dict instead of solo variables so they can be called with a string passed from the server
var info = {
	uuid = "null",
	type = "null",
	image_path = "null",
	details = "null",
	position = Vector2(),
	size = Vector2(),
	layer = 0
}

# When to update server:
# On asset creation
# On asset deletion
# On layer reorder
# On moving asset
# On resizing asset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if asset_dragging:
		var tween = get_tree().create_tween()
		
		tween.tween_property(self, "position", Vector2(get_viewport().get_mouse_position().x - difference_x, get_viewport().get_mouse_position().y - difference_y), delay * delta)
		info["position"] = Vector2(get_viewport().get_mouse_position().x - difference_x, get_viewport().get_mouse_position().y - difference_y)

func create(type: String, image_path: String, index: int, size: Vector2):
	var txt_file_path = "res://assets/" + str(type) + "s/descriptions/" + str(type) + "_descriptions.txt"
	var file = FileAccess.open(txt_file_path, FileAccess.READ)
	var description
	
	info["uuid"] = generate_uuid()
	info["type"] = type
	info["image_path"] = image_path
	
	for i in range(index + 1):
		description = file.get_line()
	
	info["details"] = description
	info["size"] = Vector2(0, 0)
	info["layer"] = 0

# UUID follows an 8-4-4-4-12 hex-and dash format
func generate_uuid() -> String:
	randomize() # reset seed of pseudo-rangom number generator
	var uuid:String
	var section_lengths = [8, 4, 4, 4, 12]
	
	for i in section_lengths:
		for j in range(i):
			uuid += hash_chars[randi_range(0, 15)] # randi_range is inclusive of both ends
		uuid += "-"
		
	uuid = uuid.trim_suffix("-") # get rid of the excess - added to the end
	
	return uuid

func _on_gui_input(event: InputEvent):
	# mouse presses
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			asset_selected = true
			
			difference_x = get_viewport().get_mouse_position().x - self.position.x
			difference_y = get_viewport().get_mouse_position().y - self.position.y
			
		else: # the event is the mouse button being released
			asset_selected = false
			asset_dragging = false
			
	# mouse drags
	elif event is InputEventMouseMotion and asset_selected:
		asset_dragging = true
		
