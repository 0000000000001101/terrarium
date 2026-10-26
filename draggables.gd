# The code in here is kind of ineffective with the groups and should be refactored later

extends TextureRect

var asset_selected := false
var asset_being_dragged = null
var delay = 10
var index
var count := 0
var animal_count := 0
var animal_assets

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animal_assets = get_tree().get_nodes_in_group("animal_assets")

# called every xx interval
func _physics_process(delta: float) -> void:
	if asset_being_dragged != null:
		var animal_deployed_assets = get_tree().get_nodes_in_group("animal_deployed_assets")
		
		var tween = get_tree().create_tween()
		
		if asset_being_dragged == "animal":
			tween.tween_property(animal_deployed_assets[0], "position", get_viewport().get_mouse_position(), delay * delta)

# called whenever select gui elements are interacted with. called from inventory.gd
func _on_gui_input(event: InputEvent, name: String, size: Vector2) -> void:
	
	# mouse presses
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			asset_selected = true
			
			if name.contains("animal"):
				create_drag_image("animal", animal_assets, name, size)
				animal_count += 1
				
			
			count += 1
		else: # the event is the mouse button being released
			asset_selected = false
			asset_being_dragged = null
			
			# call server to add a deployed_asset to its list of deployed_assets
			if name.contains("animal"):
				ServerManager.create_deployed_asset("animal", Inventory.animal_images[index], index, size, get_viewport().get_mouse_position())
		
				get_tree().call_group("deployed_assets", "queue_free")
		
	# mouse drags
	elif event is InputEventMouseMotion and asset_selected:
		
		if name.contains("animal"):
			asset_being_dragged = "animal"
			
		elif name.contains("plant"):
			pass # to be filled later
		
		
		#print("dragged: " + name)

func create_drag_image(type:String, assets:Array, name, size: Vector2) -> void:
	var canvas = get_tree().root.find_child("Canvas", true, false)
	
	for i in range(len(assets)):
		if name == assets[i].name:
			index = i
			
	#print(index)
	
	var image_copy = TextureRect.new()
	
	image_copy.name = "animal_deployed_asset" + str(animal_count)
	#print(animal_count)
	image_copy.texture = load(Inventory.animal_images[index])
	image_copy.expand_mode = image_copy.EXPAND_IGNORE_SIZE
	
	image_copy.custom_minimum_size = assets[index].custom_minimum_size
	image_copy.size.x = 100
	#print(assets[index].custom_minimum_size)
	
	canvas.add_child(image_copy)
	
	image_copy.add_to_group("deployed_assets")
	image_copy.add_to_group(type + "_deployed_assets")
