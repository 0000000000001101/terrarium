# file set as an Autoload

extends Control

signal dragged
static var animal_images
static var plant_images

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Set anchor settings to default
	#set_anchors_preset(Control.PRESET_FULL_RECT)
	#set_offsets_preset(Control.PRESET_FULL_RECT)
	var inventory = get_tree().root.find_child("Inventory", true, false)
	var tab_container = get_tree().root.find_child("MyTabContainer", true, false)
	
	inventory.size.y = get_viewport_rect().size.y
	inventory.size.x = (get_viewport_rect().size.x * 0.25) # hard coding 0.25 rather than anchor_right gave issues: might be 0.0 at runtime.
	inventory.custom_minimum_size.x = (get_viewport_rect().size.x * 0.25)
	tab_container.custom_minimum_size.x = (get_viewport_rect().size.x * 0.25)

	animal_images = create_image_array("res://assets/animals")
	plant_images = create_image_array("res://assets/plants")

	load_images(animal_images, "animal")
	load_images(plant_images, "plant")
	
	inventory.position = Vector2(0, 0)
	tab_container.position = Vector2(0, 0)
	
	# There is some weird sizing discrepancies where the children are bigger than their parents. If you have time later, try to figure this out.
	inventory.size.y = get_viewport_rect().size.y
	inventory.size.x = (get_viewport_rect().size.x * 0.25) # hard coding 0.25 rather than anchor_right gave issues: might be 0.0 at runtime.
	inventory.position = Vector2(0, 0)
	tab_container.global_position = Vector2(0, 0)
	
	#print_sizing_details()

	# .connect() functions as an event listener. size_changed is the event, called a signal in godot.
	get_tree().root.size_changed.connect(_on_window_resized)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func create_image_array(path: String) -> Variant:
	var dir = DirAccess.open(path)
	var array: Array[String] = []
	if dir:
		dir.list_dir_begin() # initializes stream
		var file_name: String = dir.get_next()
		while file_name != "":
			# skip over non-image files. ".import" are auto-created upon import.
			if not file_name.ends_with(".import") and not file_name.ends_with(".yaml") and not file_name.ends_with(".txt") and not file_name.ends_with("descriptions"):
				array.append(path + "/" + file_name)
			file_name = dir.get_next()
		return array
	else:
		print("Error with iterating through directory " + dir.to_string())
		return null
		
# might not need thiss
func create_name_array(image_array: Array[String]) -> Variant:
	var array: Array[String] = []
	var new_name:String
	
	for path in image_array:
		new_name = path.split(".")[0]
		new_name = new_name.split("/")[len(new_name.split("/")) - 1]
		array.append(new_name)
	
	return array
	
func _on_window_resized() -> void:
	var assets = get_tree().get_nodes_in_group("animal_assets")
	
	var tab_container = get_tree().root.find_child("MyTabContainer", true, false)
	var animals_container = get_tree().root.find_child("Animals", true, false)
	var inventory = get_tree().root.find_child("Inventory", true, false)
	
	inventory.size.y = get_viewport_rect().size.y
	inventory.size.x = (get_viewport_rect().size.x * 0.25) # hard coding 0.25 rather than anchor_right gave issues: might be 0.0 at runtime.
	inventory.position = Vector2(0, 0)
	tab_container.global_position = Vector2(0, 0)
	
	tab_container.size.y = inventory.size.y
	tab_container.size.x = inventory.size.x
	animals_container.size.y = inventory.size.y - 45
	
	var asset_size = inventory.size.x / 2
	
	var full_asset_sizes:Array[float]
	
	# change the size of every textureRect in group "library_assets"
	for i in range(0, len(assets), 2):
		if i + 1 <= len(assets) - 1: # accessing 2 assets at a time
			if assets[i] is TextureRect and assets[i + 1] is TextureRect:
				full_asset_sizes = resize_multiple_assets(load(str(assets[i].texture.resource_path)), load(str(assets[i + 1].texture.resource_path)), asset_size)
				#assets[i].custom_minimum_size.x = randi_range(100, 500)
				assets[i].custom_minimum_size.x = full_asset_sizes[0]
				assets[i + 1].custom_minimum_size.x = full_asset_sizes[1]
				
				assets[i].custom_minimum_size.y = asset_size
				assets[i + 1].custom_minimum_size.y = asset_size
		else: # 1 image left
			if assets[i] is TextureRect:
				assets[i].custom_minimum_size.x = asset_size
				
				assets[i].custom_minimum_size.y = asset_size
	
	#print_sizing_details()

# used for debugging resizing issues
func print_sizing_details() -> void:
	
	var grid = get_tree().root.find_child("AnimalVBox", true, false)
	var animals = get_tree().root.find_child("Animals", true, false)
	var margin = get_tree().root.find_child("AnimalMargin", true, false)
	var tab_container = get_tree().root.find_child("MyTabContainer", true, false)
	var scroll_container = get_tree().root.find_child("AnimalScroll", true, false)
	var inventory = get_tree().root.find_child("Inventory", true, false)
	var canvas = get_tree().root.find_child("Canvas", true, false)
	var asset_size = inventory.size.x / 2
	
	print("inventory: " + str(inventory.size))
	print("canvas: " + str(canvas.size))
	print("tab: " + str(tab_container.size))
	print("animals: " + str(animals.size))
	print("margin: " + str(margin.size))
	print("scroll: " + str(scroll_container.size))
	print("vbox: " + str(grid.size))
	print("\nasset_size: " + str(asset_size))
	print("anchor_right: " + str(tab_container.anchor_right))
	print("viewport: " + str(get_viewport_rect().size))
	print("Inventory Global Position: ", inventory.global_position)
	print("tab Global Position: ", tab_container.global_position)
	print("")
	
func load_images(paths: Array[String], type: String) -> void:
	
	var index:int = 0
	var full_asset_sizes:Array[float]
	
	# get tree items
	var grid = get_tree().root.find_child(type + "VBox", true, false)
	var tab_container = get_tree().root.find_child("MyTabContainer", true, false)
	var inventory = get_tree().root.find_child("Inventory", true, false)
	var asset_size = inventory.size.x * tab_container.anchor_right / 2
	
	for i in range(0, len(paths), 2):
		if i + 1 <= len(paths) - 1: # accessing two images at a time. gdscript does not natively support try except blocks
			# create new TextureRects
			var new_rect1 = TextureRect.new()
			var new_rect2 = TextureRect.new()
			
			# assign its properties
			new_rect1.name = type + str(index)
			index += 1
			new_rect2.name = type + str(index)
			index += 1
			
			new_rect1.texture = load(paths[i])
			new_rect2.texture = load(paths[i + 1])
			
			# scaling the images horizontally based on their horizontal ratios
			
			full_asset_sizes = resize_multiple_assets(load(paths[i]), load(paths[i + 1]), asset_size)
			
			new_rect1.custom_minimum_size.x = full_asset_sizes[0]
			new_rect2.custom_minimum_size.x = full_asset_sizes[1]
			
			new_rect1.custom_minimum_size.y = asset_size
			new_rect2.custom_minimum_size.y = asset_size
			
			new_rect1.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			new_rect1.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED

			new_rect2.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			new_rect2.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
			
			# add them to the VBoxContainer, each within an HBoxContainer
			var h_box = HBoxContainer.new()
			
			h_box.add_child(new_rect1)
			h_box.add_child(new_rect2)
			
			grid.add_child(h_box)
			
			# add textureRect nodes to group "type_assets". If group does not yet exist, it is created first.
			new_rect1.add_to_group(type + "_assets")
			new_rect2.add_to_group(type + "_assets")
			
			# make draggable
			new_rect1.gui_input.connect(Draggables._on_gui_input.bind(new_rect1.name, new_rect1.custom_minimum_size)) # gui_input is a signal
			new_rect2.gui_input.connect(Draggables._on_gui_input.bind(new_rect2.name, new_rect2.custom_minimum_size))
			
		else: # only one image left
			
			#create one new textureRect
			var new_rect = TextureRect.new()
			
			# set attributes
			new_rect.name = type + str(index)
			index += 1
			
			new_rect.texture = load(paths[i])
			new_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			new_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
			# new_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL # expand image to fill the entire hbox's width
			
			new_rect.custom_minimum_size.x = asset_size
			new_rect.custom_minimum_size.y = asset_size
			
			# add to the tree
			var h_box = HBoxContainer.new()
			
			h_box.add_child(new_rect)
			grid.add_child(h_box)
			
			# add node to group "type_assets" (once they are in the tree)
			new_rect.add_to_group(type + "_assets")
			
			
			# make draggable
			new_rect.gui_input.connect(Draggables._on_gui_input.bind(new_rect.name, new_rect.custom_minimum_size))
	
func resize_multiple_assets(image1: CompressedTexture2D , image2: CompressedTexture2D , asset_size: int) -> Array[float]:
	var size_list:Array[float] = [0, 0]
	
	var image1_size:Vector2 = image1.get_size()
	var image2_size:Vector2 = image2.get_size()
	
	var aspect_ratio1 = float(image1_size.x) / float(image1_size.y)
	var aspect_ratio2 = float(image2_size.x) / float(image2_size.y)
	
	var img1_wider = aspect_ratio1 > aspect_ratio2
	
	var ratio
	
	if aspect_ratio1 < aspect_ratio2:
		ratio = 1 - (aspect_ratio1 / aspect_ratio2)
	else:
		ratio = 1 - (aspect_ratio2 / aspect_ratio1)
	
	if img1_wider: # first image is wider
		size_list[0] = asset_size + asset_size * ratio
		size_list[1] = asset_size - asset_size * ratio
	else: # second image is wider
		size_list[0] = asset_size - asset_size * ratio
		size_list[1]  = asset_size + asset_size * ratio
		
	return size_list
