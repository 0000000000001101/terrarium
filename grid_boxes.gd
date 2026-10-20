# file set as an Autoload

extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var animal_images = create_image_array("res://assets/animals")
	
	for i in range(0, len(animal_images), 2):
		if i + 1 <= len(animal_images) - 1: # accessing two images at a time
			# create new TextureRects
			var new_rect1 = TextureRect.new()
			var new_rect2 = TextureRect.new()
			
			# assign its properties
			new_rect1.texture = load(animal_images[i])
			new_rect2.texture = load(animal_images[i + 1])
			
			var num = 150
			
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
				new_rect1.custom_minimum_size.x = num + num * ratio #236
				new_rect2.custom_minimum_size.x = num - num * ratio #164
			else: # second image is wider
				new_rect1.custom_minimum_size.x = num - num * ratio #236
				new_rect2.custom_minimum_size.x = num + num * ratio
			
			new_rect1.custom_minimum_size.y = num
			new_rect2.custom_minimum_size.y = num
			
			new_rect1.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			new_rect1.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED

			new_rect2.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			new_rect2.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
			
			# add them to the VBoxContainer, each within an HBoxContainer
			var grid = get_tree().root.find_child("MyVBoxContainer", true, false)
			var h_box = HBoxContainer.new()
			#h_box.offset_transform_enabled = true
			#h_box.offset_top = 300
			
			h_box.add_child(new_rect1)
			h_box.add_child(new_rect2)
			
			grid.add_child(h_box)
		else: # only one image left
			print("only one image left")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_image_array(path: String) -> Variant:
	var dir = DirAccess.open(path)
	var array: Array[String] = []
	if dir:
		dir.list_dir_begin() # initializes stream
		var file_name: String = dir.get_next()
		while file_name != "":
			if not file_name.ends_with(".import"): # skip over .import files that are auto-created upon image imports
				array.append(path + "/" + file_name)
			file_name = dir.get_next()
		return array
	else:
		print("Error with iterating through directory " + dir.to_string())
		return null

# overriding built-in gdscript function
func _get_drag_data(at_position: Vector2) -> Variant:
	pass
	return null
