# file set as an Autoload

extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	var index:int = 0

	var animal_images = create_image_array("res://assets/animals")
	var animal_names = create_name_array(animal_images)
	
	var grid = get_tree().root.find_child("MyVBoxContainer", true, false)
	var animals = get_tree().root.find_child("Animals", true, false)
	var margin = get_tree().root.find_child("MyMarginContainer", true, false)
	var tab_container = get_tree().root.find_child("MyTabContainer", true, false)
	var scroll_container = get_tree().root.find_child("MyTabContainer", true, false)
	var canvas = get_tree().root.find_child("Canvas", true, false)
	var asset_size = canvas.size.x * tab_container.anchor_right / 2
	
	print_sizing_details()
	
	#regardless of fullscreen:
	#tab: 288.0
	#animals: 1.0
	#margin: 20.0
	#scroll: 288.0
	#vbox: 0.0

	for i in range(0, len(animal_images), 2):
		if i + 1 <= len(animal_images) - 1: # accessing two images at a time
			# create new TextureRects
			var new_rect1 = TextureRect.new()
			var new_rect2 = TextureRect.new()
			
			# assign its properties
			new_rect1.name = "asset" + str(index)
			index += 1
			new_rect2.name = "asset" + str(index)
			index += 1
			
			new_rect1.texture = load(animal_images[i])
			new_rect2.texture = load(animal_images[i + 1])
			
			# scaling the images horizontally based on their horizontal ratios
			var image1_size:Vector2 = load(animal_images[i]).get_size()
			var image2_size:Vector2 = load(animal_images[i + 1]).get_size()
			
			var img1_bigger = image1_size.x > image2_size.x
			
			var aspect_ratio1 = image1_size.x / image1_size.y
			var aspect_ratio2 = image2_size.x / image2_size.y
			
			var ratio
			
			if aspect_ratio1 > aspect_ratio2:
				ratio = 1 - (aspect_ratio1 / aspect_ratio2)
			else:
				ratio = 1 - (aspect_ratio2 / aspect_ratio1)
			
			if img1_bigger: # first image is wider
				new_rect1.custom_minimum_size.x = asset_size + asset_size * ratio #236
				new_rect2.custom_minimum_size.x = asset_size - asset_size * ratio #164
			else: # second image is wider
				new_rect1.custom_minimum_size.x = asset_size - asset_size * ratio #236
				new_rect2.custom_minimum_size.x = asset_size + asset_size * ratio
			
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
			
			#print("size of hbox: " + str(h_box.size.x)) # 0
			
			grid.add_child(h_box)
			
			# add
		else: # only one image left
			pass
			#create one new textureRect
			var new_rect = TextureRect.new()
			
			# set attributes
			new_rect.texture = load(animal_images[i])
			new_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			new_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
			# new_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL # expand image to fill the entire hbox's width
			
			new_rect.custom_minimum_size.x = asset_size
			new_rect.custom_minimum_size.y = asset_size
			
			# add to the tree
			var h_box = HBoxContainer.new()
			
			h_box.add_child(new_rect)
			grid.add_child(h_box)
			
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
			if not file_name.ends_with(".import") and not file_name.ends_with(".yaml"): # skip over .import files that are auto-created upon image imports
				array.append(path + "/" + file_name)
			file_name = dir.get_next()
		return array
	else:
		print("Error with iterating through directory " + dir.to_string())
		return null
		
func create_name_array(image_array: Array[String]) -> Variant:
	var array: Array[String] = []
	var new_name:String
	
	for path in image_array:
		new_name = path.split(".")[0]
		new_name = new_name.split("/")[len(new_name.split("/")) - 1]
		array.append(new_name)
	
	#print(array)
	return array

# overriding built-in gdscript function
func _get_drag_data(_at_position: Vector2) -> Variant:
	pass
	return null
	
func _on_window_resized() -> void:
	print("window resized")
	print_sizing_details()

func print_sizing_details() -> void:
	var grid = get_tree().root.find_child("MyVBoxContainer", true, false)
	var animals = get_tree().root.find_child("Animals", true, false)
	var margin = get_tree().root.find_child("MyMarginContainer", true, false)
	var tab_container = get_tree().root.find_child("MyTabContainer", true, false)
	var scroll_container = get_tree().root.find_child("MyTabContainer", true, false)
	var canvas = get_tree().root.find_child("Canvas", true, false)
	var asset_size = canvas.size.x * tab_container.anchor_right / 2
	
	print("canvas: " + str(canvas.size.x))
	print("tab: " + str(tab_container.size.x))
	print("animals: " + str(animals.size.x))
	print("margin: " + str(margin.size.x))
	print("scroll: " + str(scroll_container.size.x))
	print("vbox: " + str(grid.size.x))
	print("\nnum: " + str(asset_size))
	print("anchor_right: " + str(tab_container.anchor_right))
