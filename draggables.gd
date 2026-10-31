# The code in here is kind of ineffective with the groups and should be refactored later

class_name Draggable
extends TextureRect

var asset_selected := false
var asset_being_dragged = null
var delay = 5
var index
var count := 0
var animal_assets
var plant_assets

var image_path

# offset between image position and mouse position
var difference_x
var difference_y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Godot creates children before parents. Wait for the parent (Inventory) to be created first
	await get_tree().process_frame
	
	animal_assets = get_tree().get_nodes_in_group("animal_assets")
	plant_assets = get_tree().get_nodes_in_group("plant_assets")

# called every xx interval
func _physics_process(delta: float) -> void:
	if asset_being_dragged != null:
		var deployed_assets = get_tree().get_nodes_in_group("deployed_assets")
		
		var tween = get_tree().create_tween()
		
		if asset_being_dragged != null:
			tween.tween_property(deployed_assets[0], "position", Vector2(get_viewport().get_mouse_position().x - difference_x, get_viewport().get_mouse_position().y - difference_y), delay * delta)
			
# called whenever select gui elements are interacted with. called from inventory.gd
func _on_gui_input(event: InputEvent, name: String, size: Vector2) -> void:
	# mouse presses
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			asset_selected = true
			
			if name.contains("animal"):
				create_drag_image("animal", animal_assets, name, size)
				
				var deployed_assets = get_tree().get_nodes_in_group("deployed_assets")
				difference_x = get_viewport().get_mouse_position().x - deployed_assets[0].position.x
				difference_y = get_viewport().get_mouse_position().y - deployed_assets[0].position.y
			
			elif name.contains("plant"):
				create_drag_image("plant", plant_assets, name, size)
				
				var deployed_assets = get_tree().get_nodes_in_group("deployed_assets")
				difference_x = get_viewport().get_mouse_position().x - deployed_assets[0].position.x
				difference_y = get_viewport().get_mouse_position().y - deployed_assets[0].position.y
				
			count += 1
				
		else: # the event is the mouse button being released
			asset_selected = false
			asset_being_dragged = null
			
			var deployed_assets = get_tree().get_nodes_in_group("deployed_assets")
			
			# call server to add a deployed_asset to its list of deployed_assets
			if name.contains("animal"):
				ServerManager.create_deployed_asset("animal", image_path, index, size, deployed_assets[0].position)
				# take "Draggables" node off screen
				get_tree().call_group("deployed_assets", "queue_free")
				
			elif name.contains("plant"):
				ServerManager.create_deployed_asset("plant", image_path, index, size, deployed_assets[0].position)
				# take "Draggables" node off screen
				get_tree().call_group("deployed_assets", "queue_free")
		
	# mouse drags
	elif event is InputEventMouseMotion and asset_selected:
		
		if name.contains("animal"):
			asset_being_dragged = "animal"
			
		elif name.contains("plant"):
			asset_being_dragged = "plant"

func create_drag_image(type:String, assets:Array, name, size: Vector2) -> void:
	var canvas = get_tree().root.find_child("Canvas", true, false)
	
	for i in range(len(assets)):
		if name == assets[i].name:
			index = i
	
	var image_copy = TextureRect.new()
	
	if type == "animal":
		image_copy.texture = load(image_path)
	elif type == "plant":
		image_copy.texture = load(image_path)
	image_copy.expand_mode = image_copy.EXPAND_IGNORE_SIZE
	
	image_copy.custom_minimum_size = assets[index].custom_minimum_size
	image_copy.size.x = 100
	
	var inventory_assets = get_tree().get_nodes_in_group(type + "_assets")
	image_copy.position.x = inventory_assets[index].global_position.x
	image_copy.position.y = inventory_assets[index].get_parent().global_position.y
	
	canvas.add_child(image_copy)
	
	image_copy.add_to_group("deployed_assets")
