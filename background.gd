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
	
	self.gui_input.connect(_on_gui_input)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_released():
			# Hide any visible radial, resize menus
			var draggables = get_tree().root.find_children("*", "DeployedAsset", true, false)
			for asset in draggables:
				if asset.radial_menu.visible: # both menus would be visible at once. Only need to check for one
					asset.hide_radial_menu()
					asset.hide_resize_menu()
					asset.radial_menu_showing = false
					DeployedAsset.any_menu_showing = false
			
