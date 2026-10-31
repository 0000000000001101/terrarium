class_name RadialMenu
extends Control

static var radius = 90
static var speed = 0.25
var rotating = false
var theta = 0
var starting_position
var starting_position_x
var starting_position_y
var starting_angle
var diff_x
var diff_y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# creating and adding all buttons
	var delete_button = Button.new()
	delete_button.name = "DeleteButton"
	delete_button.icon = load("res://assets/smiley placeholder.png")
	delete_button.flat = true # rid of the border
	#description_button.anchor_top = 0.0 # Don't need. The tween overrides positioning
	#description_button.anchor_left = 0.5
	#description_button.anchor_right = 0.5
	delete_button.gui_input.connect(on_delete_button_clicked)
	self.add_child(delete_button)
	
	var rotate_button = Button.new()
	rotate_button.name = "RotateButton"
	rotate_button.icon = load("res://assets/smiley placeholder.png")
	rotate_button.flat = true
	#rotate_button.anchor_top = 0.0
	#rotate_button.anchor_left = 0.5
	#rotate_button.anchor_right = 0.5
	rotate_button.gui_input.connect(on_rotate_button_clicked)
	self.add_child(rotate_button)
	
	var reorder_layer_button = Button.new()
	reorder_layer_button.name = "ReorderLayerButton"
	reorder_layer_button.icon = load("res://assets/smiley placeholder.png")
	reorder_layer_button.flat = true
	#reorder_layer_button.anchor_top = 0.0
	#reorder_layer_button.anchor_left = 0.5
	#reorder_layer_button.anchor_right = 0.5
	reorder_layer_button.gui_input.connect(on_reorder_layer_button_clicked)
	self.add_child(reorder_layer_button)
	
	var description_button = Button.new()
	description_button.name = "DescriptionButton"
	description_button.icon = load("res://assets/smiley placeholder.png")
	description_button.flat = true # rid of the border
	#description_button.anchor_top = 0.0 # Don't need. The tween overrides positioning
	#description_button.anchor_left = 0.5
	#description_button.anchor_right = 0.5
	description_button.gui_input.connect(on_description_button_clicked)
	self.add_child(description_button)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_delete_button_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("delete layer button clicked")
			self.get_parent().free()

func on_reorder_layer_button_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("reorder layer button clicked")
	
func on_rotate_button_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("rotate button clicked")
			#starting_angle = self.get_parent().rotation
			rotating = true
			
		elif event.is_released():
			print("rotate button released")
			rotating = false
			# update ServerManager
			ServerManager.asset_rotated(get_parent())
			
	elif event is InputEventMouseMotion:
		if rotating:
			diff_x = get_parent().pivot_point.x - get_viewport().get_mouse_position().x
			diff_y = get_parent().pivot_point.y - get_viewport().get_mouse_position().y
			theta = - atan2(diff_x, diff_y)
			print(rad_to_deg(theta))
	
func on_description_button_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("description button clicked")
