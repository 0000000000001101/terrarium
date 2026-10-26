extends TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_deployed_asset(type: String, string_path: String, index: int):
	var deployable = DeployedAsset.new()
	deployable.create(type, string_path, index)
