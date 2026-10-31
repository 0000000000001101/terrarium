extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var glass = TextureRect.new()
	if GeneralManager.glass_selected == 0:
		print("Error: No glass enclosure selected.")
	glass.texture = load(GeneralManager.glass_path)
	glass.size = Vector2(500, 500)
	glass.position = Vector2(400, 100)
	add_child(glass)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
