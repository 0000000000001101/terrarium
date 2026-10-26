extends TextureRect



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_deployed_asset(type: String, string_path: String, index: int, size: Vector2, position: Vector2):
	var deployable = DeployedAsset.new()
	
	deployable.texture = load(string_path)
	deployable.create(type, string_path, index, size)
	deployable.gui_input.connect(deployable._on_gui_input)
	
	deployable.expand_mode = deployable.EXPAND_IGNORE_SIZE
	deployable.custom_minimum_size = size
	deployable.position = position
	print(deployable.size)
	
	var canvas = get_tree().root.find_child("Canvas", true, false)
	canvas.add_child(deployable)
