# file set as an Autoload

class_name Inventory
extends Control

static var animal_images = []
static var plant_images = []

# get tree elements once they load into the tree
@onready var inventory = self
@onready var tab_container = get_tree().root.find_child("MyTabContainer", true, false)
@onready var animals_container = get_tree().root.find_child("Animals", true, false)
@onready var plants_container = get_tree().root.find_child("Plants", true, false)
@onready var animal_vbox = get_tree().root.find_child("animalVBox", true, false)
@onready var plant_vbox = get_tree().root.find_child("plantVBox", true, false)
@onready var margin = get_tree().root.find_child("AnimalMargin", true, false)
@onready var scroll_container = get_tree().root.find_child("AnimalScroll", true, false)
@onready var canvas = get_tree().root.find_child("Canvas", true, false)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("inventory script running")
	
	# Set anchor settings to default
	#set_anchors_preset(Control.PRESET_FULL_RECT)
	#set_offsets_preset(Control.PRESET_FULL_RECT)
	
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
	var animal_assets = get_tree().get_nodes_in_group("animal_assets")
	var plant_assets = get_tree().get_nodes_in_group("animal_assets")
	
	inventory.size.y = get_viewport_rect().size.y
	inventory.size.x = (get_viewport_rect().size.x * 0.25) # hard coding 0.25 rather than anchor_right gave issues: might be 0.0 at runtime.
	inventory.position = Vector2(0, 0)
	tab_container.global_position = Vector2(0, 0)
	
	tab_container.size.y = inventory.size.y
	tab_container.size.x = inventory.size.x
	animals_container.size.y = inventory.size.y - 45
	plants_container.size.y = inventory.size.y - 45
	
	var asset_size = inventory.size.x * tab_container.anchor_right / 2
	# asset widths of the pairs of side by side nodes
	var full_asset_sizes:Array[float]
	
	# change the size of every textureRect in group "animal_assets"
	for i in range(0, len(animal_assets), 2):
		if i + 1 <= len(animal_assets) - 1: # accessing 2 assets at a time
			if animal_assets[i] is TextureRect and animal_assets[i + 1] is TextureRect:
				full_asset_sizes = resize_multiple_assets(load(str(animal_assets[i].texture.resource_path)), load(str(animal_assets[i + 1].texture.resource_path)), asset_size)
				#animal_assets[i].custom_minimum_size.x = randi_range(100, 500)
				animal_assets[i].custom_minimum_size.x = full_asset_sizes[0]
				animal_assets[i + 1].custom_minimum_size.x = full_asset_sizes[1]
				
				animal_assets[i].custom_minimum_size.y = asset_size
				animal_assets[i + 1].custom_minimum_size.y = asset_size
		else: # 1 image left
			if animal_assets[i] is TextureRect:
				animal_assets[i].custom_minimum_size.x = asset_size
				
				animal_assets[i].custom_minimum_size.y = asset_size
				
	# change the size of every textureRect in group "plant_assets"
	for i in range(0, len(plant_assets), 2):
		if i + 1 <= len(plant_assets) - 1: # accessing 2 assets at a time
			if plant_assets[i] is TextureRect and plant_assets[i + 1] is TextureRect:
				full_asset_sizes = resize_multiple_assets(load(str(plant_assets[i].texture.resource_path)), load(str(plant_assets[i + 1].texture.resource_path)), asset_size)
				#plant_assets[i].custom_minimum_size.x = randi_range(100, 500)
				plant_assets[i].custom_minimum_size.x = full_asset_sizes[0]
				plant_assets[i + 1].custom_minimum_size.x = full_asset_sizes[1]
				
				plant_assets[i].custom_minimum_size.y = asset_size
				plant_assets[i + 1].custom_minimum_size.y = asset_size
		else: # 1 image left
			if plant_assets[i] is TextureRect:
				plant_assets[i].custom_minimum_size.x = asset_size
				
				plant_assets[i].custom_minimum_size.y = asset_size
	
	#print_sizing_details()

# used for debugging resizing issues
func print_sizing_details() -> void:
	
	var asset_size = inventory.size.x * tab_container.anchor_right / 2
	
	print("inventory: " + str(inventory.size))
	print("canvas: " + str(canvas.size))
	print("tab: " + str(tab_container.size))
	print("animals: " + str(animals_container.size))
	print("margin: " + str(margin.size))
	print("scroll: " + str(scroll_container.size))
	print("animal vbox: " + str(animal_vbox.size))
	print("\nasset_size: " + str(asset_size))
	print("anchor_right: " + str(tab_container.anchor_right))
	print("viewport: " + str(get_viewport_rect().size))
	print("Inventory Global Position: ", inventory.global_position)
	print("tab Global Position: ", tab_container.global_position)
	print("")
	
func load_images(paths: Array[String], type: String) -> void:
	
	var index:int = 0
	var full_asset_sizes:Array[float]
	
	var asset_size = inventory.size.x * tab_container.anchor_right / 2
	
	for i in range(0, len(paths), 2):
		if i + 1 <= len(paths) - 1: # accessing two images at a time. gdscript does not natively support try except blocks
			# create new TextureRects
			var new_rect1 = Draggable.new()
			var new_rect2 = Draggable.new()
			
			# assign its properties
			new_rect1.name = type + str(index)
			index += 1
			new_rect2.name = type + str(index)
			index += 1
			
			new_rect1.texture = load(paths[i])
			new_rect2.texture = load(paths[i + 1])
			
			new_rect1.image_path = paths[i]
			new_rect2.image_path = paths[i + 1]
			
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
			
			if type == "animal":
				animal_vbox.add_child(h_box)
			elif type == "plant":
				plant_vbox.add_child(h_box)
			
			# add textureRect nodes to group "type_assets". If group does not yet exist, it is created first.
			new_rect1.add_to_group(type + "_assets")
			new_rect2.add_to_group(type + "_assets")
			
			# make draggable
			new_rect1.gui_input.connect(new_rect1._on_gui_input.bind(new_rect1.name, new_rect1.custom_minimum_size)) # gui_input is a signal
			new_rect2.gui_input.connect(new_rect2._on_gui_input.bind(new_rect2.name, new_rect2.custom_minimum_size))
			
		else: # only one image left
			
			#create one new textureRect
			var new_rect = Draggable.new()
			
			# set attributes
			new_rect.name = type + str(index)
			index += 1
			
			new_rect.texture = load(paths[i])
			new_rect.image_path = paths[i]
			
			new_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			new_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
			# new_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL # expand image to fill the entire hbox's width
			
			new_rect.custom_minimum_size.x = asset_size
			new_rect.custom_minimum_size.y = asset_size
			
			# add to the tree
			var h_box = HBoxContainer.new()
			
			h_box.add_child(new_rect)
			if type == "animal":
				animal_vbox.add_child(h_box)
			elif type == "plant":
				plant_vbox.add_child(h_box)
			
			# add node to group "type_assets" (once they are in the tree)
			new_rect.add_to_group(type + "_assets")
			
			# make draggable
			new_rect.gui_input.connect(new_rect._on_gui_input.bind(new_rect.name, new_rect.custom_minimum_size))
	
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
