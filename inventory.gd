# file set as an Autoload

class_name Inventory
extends Control

# Issue with dynamically loading. I believe it is because .pngs are converted to .imports upon export of the applicatoin
const animal_images: Array[String] = [
	"res://assets/animals/Cubaris Sp Rubber Ducky.png",
	"res://assets/animals/Epipedobates Anthonyi.png",
	"res://assets/animals/Eublepharis Macularius.png",
	"res://assets/animals/Helix Pomatia.png"
]

const plant_images: Array[String] = [
	"res://assets/plants/Aeschynanthus Sp Thailand Varegiated.png",
	"res://assets/plants/Biophytum Sensitivum.png",
	"res://assets/plants/Cryptanthus Bivittatus.png",
	"res://assets/plants/Marcgravia.png",
	"res://assets/plants/Tradescantia Nanouk.png"
]

# Issue with dynamically loading 
const animal_descriptions := {
	"Cubaris Sp Rubber Ducky": "	Also known as the Rubber Ducky Isopod, these are highly sought after isopods native to Thailand and Southeast Asia. They require advanced care: they are shy, nocturnal, and have slow reproductoin rates.\n
	They grow up to 1.5 cm in length.\n
	They require warm temperatures of 22 to 27 *C and very high humidity (80 - 90%) with a moisture gradient (one section of the tank damp with sphagnum moss, one section slightly drier).\n
	They require a deep bioactive substrate (6+ inches) with a base consisting of a mixture of coconut coir, peat moss/ABG mix. They require calcium supplimented with decayling leaf litter, rotten hardwood, and limestone/cuttlebone.\n
	They are detritivores, feeding on decaying plant matter, vegetables, fruits, and protein supplements (fish flakes, dried minnows, or shrimp pellets).",
	
	"Epipedobates Anthonyi": "	Commonly known as Anthony's posion dart frog (or the Phantasmal poison frog), these are small, beginner-friendly diurnal dart frogs native to the tropical forests of southwestern Ecuador and northwestern Peru. Captive poison dart frogs are harmless, as wild dart frogs derive their skin toxins from eating native insects.\n
	They grow to 1.9 to 2.6 cm in length.\n
	They require warm temperatures of 20 to 26 *C, with a slight drop at night.\n
	They require very high humidity (80 - 90%), which is maintained with daily misting with either reverse-osmosis water or dechlorinated water.\n
	They require a bioactive terrarium featuring a drainage layer (false bottom), ABG mix subtrate, live tropical plants and a thick layer of leaf litter.\n
	They are insectivores. Their diets mostly consist of flightless fruit flies, springtails, and dwarf isopods dusted with calcium and vitamin supplements.",
	
	"Eublepharis Macularius": "	Commonly known as the Leopard gecko, these are terrestrial lizards native to the rocky grasslands and deserts of Sourth and Central Asia. They are popular pets thanks to their docile temperatment, long lifespan (15 - 20+ years) and wide variety of colour morphs.\n
	They grow to 18 to 25 cm in length.\n
	They require a thermal gradiant with a warm basking surface of 32 - 35 *C and a cool side of 22 to 26 *C (dropping to 18 - 21 *C at night).\n
	They require low humidity (30 - 40%) across the enclosure, paired with an enclosed humid hide (lined with damp sphagnum moss or paper towels) kept around 70 - 80% to help with healthy shedding.\n
	They require an arid bioactive mix (roughly 70% organic, fertilizer-free topsoil and 30% washed play sand) with textured slate/tile (or paper towels for juveniles). Avoid loose calcium sand or crushed shells, which pose impaction risks.\n
	They are insectivores that eat live, gut-loaded insects (crickets, dubia roaches, mealworms, black soldier fly larvaue, and occasional waxworms or hornworms dusted with calcium and multivitamin supplements). A small dish of plain calcium can also be kept in the tank.",
	
	"Helix Pomatia": "	Also known as Roman snails / Burgundy snails, these are large land snails native to central and southeastern Europe. They are commonly kept for their calm natures.\n
	They grow up to 4.5 - 5 cm in shell diameter.\
	They require moderate temperatures of 15 to 22 * C and high humidity (75 - 90%), which is maintained with daily misting with dechlorinated water.\n
	They require a deep, moisture-retentive substrate (3 - 4+ inches) made of organic, fertilizer-free topsoil (or peat-free comost) mixed with leaf litter and moss.\n
	They are primarily herbivores that eat fresh vegetables and occasional fruits. They require weekly protein supplements (bloodworms / mealworms / fish flakes) and a constant source of calcium, such as cuttlebone."
}

const plant_descriptions := {
	"Aeschynanthus Sp Thailand Varegiated": "	Also known as the Variegated Thai Lipstick Plant, this is a rare, epiphytic trailing plant native to the tropical rainforests of Thailand. They are prized by collectors for their glossy, creamy-variegated leaves and bright red tubular flowers.\n
Their trailing stems grow up to 30 - 60 cm in length at a slow pace.
They require warm temperatures of 18 to 27 * C and high humidity (60 - 80%), though they can adapt to average household humidity (40 - 50%) with good airflow.\n
They require a chunky, fast-draining epiphytic substrate made of peat or coco coir mixed with fine orchid bark and perlite or pumice.\n
They require bright, indirect light to maintain their variegation and encourage blooms, along with watering when the top inch of soil dries out and diluted liquid fertilizer every 2 - 4 weeks during spring and summer.",
	
	"Biophytum Sensitivum": " Also known as the Little Tree Plant or Sensitive Plant, this is a miniature, palm-like tropical herb native to the wetlands and shaded forests of Nepal, India, and Southeast Asia. They are commonly kept in terrariums and vivariums for their feathery leaves that fold shut when touched or at night.\n
They grow up to 10 - 30 cm in height with a single woody stem topped by a rosette of pinnate leaves.
They require warm temperatures of 18 to 28 * C and high humidity (60 - 80%+), making them ideal for closed terrariums.\n
They require a light, moisture-retentive yet well-draining substrate made of peat moss or coco coir mixed with perlite and sphagnum moss.\n
They require bright, indirect light and consistently moist soil (using distilled or rainwater when possible), along with diluted liquid fertilizer every 4 - 6 weeks during spring and summer.",
	
	"Cryptanthus Bivittatus": "	Also known as the Earth Star, this is a small, terrestrial bromeliad native to the coastal forests of eastern Brazil. They are commonly kept in terrariums and vivariums for their low-growing, star-shaped rosettes of wavy, pink-and-green striped leaves.\n
They grow up to 5 - 10 cm in height and 15 - 25 cm wide in a flat, spreading rosette.
They require warm temperatures of 18 to 27 * C and moderate to high humidity (50 - 80%), which helps keep their leaf colors vibrant.\n
They require a loose, fast-draining yet moisture-retentive substrate made of peat moss or coco coir mixed with fine orchid bark and perlite.\n
They require bright, indirect light to maintain their pink coloration (low light turns them green) and lightly moist soil watered with distilled or rainwater, along with diluted fertilizer applied once a month during spring and summer.",
	
	"Marcgravia": " Also known as the Shingle Plant, this is a tropical, epiphytic climbing vine native to the rainforests of Central and South America. They are prized in vivariums for their juvenile, flattened leaves that hug and shingle tightly up vertical backgrounds, branches, and hardscape.\n
Their trailing or climbing vines grow up to 30 - 100+ cm in length, with small, overlapping leaves measuring roughly 1 - 3 cm across.
They require warm temperatures of 18 to 27 * C and high humidity (70 - 95%), which keeps their aerial roots active and gripping surfaces.\n
They require a moist, airy climbing surface (such as cork bark, tree fern fiber, or sphagnum moss walls) paired with a loose, fast-draining substrate made of coco coir, orchid bark, and sphagnum moss at the base.\n
They require low to bright, indirect light (some varieties blush pink or bronze under higher light) and frequent misting with distilled or dechlorinated water to keep the roots consistently damp without becoming waterlogged.",
	
	"Tradescantia Nanouk": "	Also known as the Fantasy Venice or Lilac Inch Plant, this is a fast-growing, trailing perennial cultivar originating from the Netherlands (bred from South American Tradescantia species). They are commonly kept as houseplants and terrarium accents for their thick, striped leaves in shades of bubblegum pink, lilac, cream, and green.\n
Their sturdy, trailing stems grow up to 30 - 60 cm in length.
They require moderate to warm temperatures of 15 to 27 * C and average to high humidity (40 - 70%), adapting easily to both open rooms and humid enclosures.\n
They require a well-draining, lightly moisture-retentive potting mix made of standard peat or coco coir soil mixed with perlite and orchid bark.\n
They require bright, indirect light to preserve their vivid pink variegation and watering at the soil level when the top 1 - 2 inches dry out (avoiding letting water sit on the leaves, which can cause brown spots), along with diluted fertilizer once a month during spring and summer."
}

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
	
	# FIXME: This is temporary, until we have a connect to server scene.
	if not GeneralManager.skip_server_connection:
		ServerManager.connect_to_server("ws://127.0.0.1:8013")
	
	# Set anchor settings to default
	#set_anchors_preset(Control.PRESET_FULL_RECT)
	#set_offsets_preset(Control.PRESET_FULL_RECT)
	
	inventory.size.y = get_viewport_rect().size.y
	inventory.size.x = (get_viewport_rect().size.x * 0.25) # hard coding 0.25 rather than anchor_right gave issues: might be 0.0 at runtime.
	inventory.custom_minimum_size.x = (get_viewport_rect().size.x * 0.25)
	tab_container.custom_minimum_size.x = (get_viewport_rect().size.x * 0.25)
	$MenuButton.position.x = tab_container.size.x - $MenuButton.size.x

	load_images(animal_images, "animal")
	load_images(plant_images, "plant")
	
	inventory.position = Vector2(0, 0)
	tab_container.position = Vector2(0, 0)
	
	# There is some weird sizing discrepancies where the children are bigger than their parents. If you have time later, try to figure this out.
	inventory.size.y = get_viewport_rect().size.y
	inventory.size.x = (get_viewport_rect().size.x * 0.25) # hard coding 0.25 rather than anchor_right gave issues: might be 0.0 at runtime.
	inventory.position = Vector2(0, 0)
	tab_container.global_position = Vector2(0, 0)
	$MenuButton.position.x = tab_container.size.x - $MenuButton.size.x
	
	#print_sizing_details()

	# .connect() functions as an event listener. size_changed is the event, called a signal in godot.
	get_tree().root.size_changed.connect(_on_window_resized)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# OLD:
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
	var plant_assets = get_tree().get_nodes_in_group("plant_assets")
	
	inventory.size.y = get_viewport_rect().size.y
	inventory.size.x = (get_viewport_rect().size.x * 0.25) # hard coding 0.25 rather than anchor_right gave issues: might be 0.0 at runtime.
	inventory.position = Vector2(0, 0)
	tab_container.global_position = Vector2(0, 0)
	$MenuButton.position.x = tab_container.size.x - $MenuButton.size.x
	
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
	print("inventory Global Position: ", inventory.global_position)
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
