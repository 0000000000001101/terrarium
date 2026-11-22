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

@onready var layer_menu = get_tree().root.find_child("LayerMenu", true, false)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# creating and adding all buttons
	var delete_button = Button.new()
	delete_button.name = "DeleteButton"
	delete_button.icon = load("res://assets/delete button.png")
	delete_button.flat = true # rid of the border
	delete_button.gui_input.connect(on_delete_button_clicked)
	self.add_child(delete_button)
	
	var rotate_button = Button.new()
	rotate_button.name = "RotateButton"
	rotate_button.icon = load("res://assets/rotate button.png")
	rotate_button.flat = true
	rotate_button.gui_input.connect(on_rotate_button_clicked)
	self.add_child(rotate_button)
	
	var reorder_layer_button = Button.new()
	reorder_layer_button.name = "ReorderLayerButton"
	reorder_layer_button.icon = load("res://assets/reorder layer button.png")
	reorder_layer_button.flat = true
	reorder_layer_button.gui_input.connect(on_reorder_layer_button_clicked)
	self.add_child(reorder_layer_button)
	
	var description_button = Button.new()
	description_button.name = "DescriptionButton"
	description_button.icon = load("res://assets/information button.png")
	description_button.flat = true # rid of the border
	description_button.gui_input.connect(on_description_button_clicked)
	self.add_child(description_button)
	
	var mirror_button = Button.new()
	mirror_button.name = "MirrorButton"
	mirror_button.icon = load("res://assets/smiley placeholder.png")
	mirror_button.flat = true # rid of the border
	mirror_button.gui_input.connect(on_mirror_button_clicked)
	self.add_child(mirror_button)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_delete_button_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# remove the asset from the LayerMenu
			for label in layer_menu.get_child(0).get_child(0).get_child(0).get_children(): # going through children until get children of LayerVBoxContainer
				if label.text == get_parent().info["name"]:
					label.queue_free()
			
			# delete the asset
			print("delete layer button clicked")
			ServerManager.asset_deleted(get_parent())
			self.get_parent().queue_free()

func on_reorder_layer_button_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if layer_menu.visible:
				hide_layer_menu()
			else:
				show_layer_menu()
	
func on_rotate_button_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			#print("rotate button clicked")
			#starting_angle = self.get_parent().rotation
			rotating = true
			
		elif event.is_released():
			#print("rotate button released")
			rotating = false
			# update ServerManager
			ServerManager.asset_rotated(get_parent())
			
	elif event is InputEventMouseMotion:
		if rotating:
			diff_x = get_parent().pivot_point.x - get_viewport().get_mouse_position().x
			diff_y = get_parent().pivot_point.y - get_viewport().get_mouse_position().y
			theta = - atan2(diff_x, diff_y)
			#print(rad_to_deg(theta))
			# NOTE: MAYBE REMOVE ME IF SPAMMY/LAGGY
			ServerManager.asset_rotated(get_parent())
	
func on_description_button_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			get_parent().description_button_pressed()
			
			get_parent().hide_radial_menu();
			get_parent().hide_resize_menu();

func on_mirror_button_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			get_parent().flip_h = not get_parent().flip_h;

func show_layer_menu() -> void:
	layer_menu.global_position = get_viewport().get_mouse_position() + Vector2(30, -20)
	if layer_menu.global_position.x + layer_menu.get_child(0).size.x > get_viewport_rect().size.x:
		layer_menu.global_position.x -= layer_menu.get_child(0).size.x * 2
		print(layer_menu.get_child(0).size.x)
	layer_menu.show()
	
	var tween = get_tree().create_tween()
	tween.tween_property(layer_menu, "scale:y", 1.0, 0.25).from(0.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
func hide_layer_menu() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(layer_menu, "scale:y", 0.0, 0.25).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	tween.finished.connect(func(): 
		layer_menu.hide()
	)
