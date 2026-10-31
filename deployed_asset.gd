class_name DeployedAsset
extends TextureRect

var hash_chars := "0123456789abcdef"

var asset_selected := false
var asset_dragging := false
var delay = 5

var difference_x
var difference_y
var pivot_point
var original_position # used in moving pivot_point when asset is moved

var start_time
var radial_menu; var resize_menu
var radial_menu_showing = false
var menu_tween_active = false
# only want one radial menu showing at once
static var any_radial_menu_showing = false

# dict instead of solo variables so they can be called with a string passed from the server
var info = {
	uuid = "null",
	type = "null",
	image_path = "null",
	description = "null",
	position = Vector2(),
	size = Vector2(),
	layer = 0,
	rotation = 0 # note to self to change the pivot_offset to size/2 every time you rotate. the default pivot point is the top left corner of the TextureRect.
	# also, rotation is in radians. use deg_to_rad(degree) if you'd like.
}

# When to update server:
# On asset creation
# On asset deletion
# On layer reorder
# On moving asset
# On resizing asset
# On rotating asset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if asset_dragging:
		var tween = get_tree().create_tween()
		
		tween.tween_property(self, "position", Vector2(get_viewport().get_mouse_position().x - difference_x, get_viewport().get_mouse_position().y - difference_y), delay * delta)
		info["position"] = Vector2(get_viewport().get_mouse_position().x - difference_x, get_viewport().get_mouse_position().y - difference_y)

	elif $RadialMenu.rotating:
		#var tween = get_tree().create_tween()
		
		# long delays cause for a glitch at the 180 mark where the image full 360 rotates
		#tween.tween_property(self, "rotation", $RadialMenu.theta, 0.5 * delta)
		rotation = lerp_angle(rotation, $RadialMenu.theta, 10.0 * delta)
		#print(str(rad_to_deg($RadialMenu.theta)))

func create(type: String, image_path: String, index: int, size: Vector2, position: Vector2):
	var txt_file_path = "res://assets/" + str(type) + "s/descriptions/" + str(type) + "_descriptions.txt"
	var file = FileAccess.open(txt_file_path, FileAccess.READ)
	var description
	
	info["uuid"] = generate_uuid()
	info["type"] = type
	info["image_path"] = image_path
	
	for i in range(index + 1):
		description = file.get_line()
	
	info["details"] = description
	info["size"] = size
	info["position"] = position
	info["layer"] = 0
	
	pivot_offset = size / 2
	pivot_point = info["position"] + pivot_offset
	print(str(info["position"]) + "!!")
	
	radial_menu = RadialMenu.new()
	radial_menu.name = "RadialMenu"
	# don't want the main control section to block mouse inputs from the DeployedAsset
	radial_menu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	radial_menu.add_to_group("radial_menus")
	radial_menu.hide()
	add_child(radial_menu)
	
	resize_menu = ResizeMenu.new()
	resize_menu.name = "ResizeMenu"
	resize_menu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	resize_menu.hide()
	add_child(resize_menu)
	
	ServerManager.asset_created(self)

# UUID follows an 8-4-4-4-12 hex-and dash format
func generate_uuid() -> String:
	randomize() # reset seed of pseudo-rangom number generator
	var uuid:String
	var section_lengths = [8, 4, 4, 4, 12]
	
	for i in section_lengths:
		for j in range(i):
			uuid += hash_chars[randi_range(0, 15)] # randi_range is inclusive of both ends
		uuid += "-"
		
	uuid = uuid.trim_suffix("-") # get rid of the excess - added to the end
	
	return uuid

func _on_gui_input(event: InputEvent):
	# mouse presses
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		
		if event.pressed: # mouse down
			start_time = Time.get_ticks_msec()
			
			asset_selected = true
			
			difference_x = get_viewport().get_mouse_position().x - self.position.x
			difference_y = get_viewport().get_mouse_position().y - self.position.y
			
			original_position = info["position"]
			
		elif event.is_released(): # the event is the mouse button being released
			asset_selected = false
			asset_dragging = false
			
			pivot_point += info["position"] - original_position
			
			if Time.get_ticks_msec() - start_time < 200:
				if not radial_menu_showing and not menu_tween_active:
					radial_menu_showing = true
					
					if DeployedAsset.any_radial_menu_showing:
						# go through radial_menu group and hide them all
						for menu in get_tree().get_nodes_in_group("radial_menus"):
							if menu.visible:
								menu.get_parent().hide_radial_menu()
								# set radial_menu_showing to false for the DeployedAsset with this menu as its child
								menu.get_parent().radial_menu_showing = false
						
					DeployedAsset.any_radial_menu_showing = true
					
					show_radial_menu()
					show_resize_menu()
					
				else:
					#print("deleting radial menu")
					radial_menu_showing = false
					DeployedAsset.any_radial_menu_showing = false
					
					hide_radial_menu()
					hide_resize_menu()
			
	# mouse drags
	elif event is InputEventMouseMotion and asset_selected:
		#print("dragged")
		asset_dragging = true
		
		# hide any radial, resize menus once you start dragging an asset
		if DeployedAsset.any_radial_menu_showing:
			# go through radial_menu group and hide them all
			for menu in get_tree().get_nodes_in_group("radial_menus"):
				if menu.visible:
					menu.get_parent().hide_radial_menu()
					menu.get_parent().hide_resize_menu() # any DeployedAsset with radial menu visible will have resize menu visible too
					# set radial_menu_showing to false for the DeployedAsset with this menu as its child
					menu.get_parent().radial_menu_showing = false
			
		radial_menu_showing = false
		DeployedAsset.any_radial_menu_showing = true
		
		hide_radial_menu()
		hide_resize_menu()
		
func show_radial_menu() -> void:
	#print("showing radial menu")
	menu_tween_active = true
	
	$RadialMenu.size = self.size
	# center the pivot point, then move it left to account for button size (ratio button size : self size)
	$RadialMenu.anchor_left = 0.5 - $RadialMenu/RotateButton.get_size().x / 2 / self.size.x
	$RadialMenu.anchor_top = $RadialMenu/RotateButton.get_size().x / self.size.x
	$RadialMenu.show()
	
	var tween = get_tree().create_tween().set_parallel(true) # allow multiple tweens to run at once
	#tw.finished.connect(func(): # function execution) # lambda, similar to arrow functions in JS
	
	var angle = deg_to_rad(230)
	for button in $RadialMenu.get_children():
		if not button.name.contains("Description"):
			tween.tween_property(button, "position", Vector2(RadialMenu.radius, 0).rotated(angle), RadialMenu.speed).from(Vector2.ZERO).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			tween.tween_property(button, "scale", Vector2.ONE, RadialMenu.speed).from(Vector2(0.5, 0.5)).set_trans(Tween.TRANS_LINEAR)
			angle += deg_to_rad(40)
		else:
			angle += deg_to_rad(30)
			tween.tween_property(button, "position", Vector2(RadialMenu.radius + 30, 0).rotated(angle), RadialMenu.speed).from(Vector2.ZERO).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			tween.tween_property(button, "scale", Vector2.ONE, RadialMenu.speed).from(Vector2(0.5, 0.5)).set_trans(Tween.TRANS_LINEAR)

func hide_radial_menu() -> void:
	#print("hiding radial menu")
	menu_tween_active = false
	
	var tween = get_tree().create_tween().set_parallel(true) # allow multiple tweens to run at once
	tween.finished.connect(func(): 
		if not menu_tween_active:
			$RadialMenu.hide()
	) # lambda, similar to arrow functions in JS
	
	for button in $RadialMenu.get_children():
		if not button.name.contains("Resize"):
			tween.tween_property(button, "position", Vector2.ZERO, RadialMenu.speed).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
			tween.tween_property(button, "scale", Vector2(0.5, 0.5), RadialMenu.speed).set_trans(Tween.TRANS_LINEAR)

func show_resize_menu() -> void:
	$ResizeMenu.show()
	
func hide_resize_menu() -> void:
	$ResizeMenu.hide()
