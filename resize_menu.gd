class_name ResizeMenu
extends Control

static var speed = 0.25

# default margin_size is 4px on all sides
var margin_size = 4
var resizing = "null"
var resize_difference: Vector2
var original_corner_position: Vector2 # The position of the corner the user is dragging to resize
var parent_original_pivot_offset: Vector2 # Original pivot offset of the DeployedAsset before resizing
var corner_pivot_offset: Vector2 # The corner the image will be resized in relation to

var rotated_resize_difference_neg
var rotated_resize_difference_pos

var parent_original_size
var parent_original_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# creating and adding all buttons
	var resize_button_tl = Button.new()
	resize_button_tl.name = "ResizeButtonTopLeft"
	resize_button_tl.icon = load("res://assets/smiley placeholder.png")
	resize_button_tl.offset_left = - resize_button_tl.icon.get_size().x / 2 - margin_size
	resize_button_tl.offset_top = - resize_button_tl.icon.get_size().y / 2 - margin_size
	resize_button_tl.flat = true
	resize_button_tl.gui_input.connect(on_resize_button_tl_clicked)
	self.add_child(resize_button_tl)
	
	var resize_button_tr = Button.new()
	resize_button_tr.name = "ResizeButtonTopRight"
	resize_button_tr.icon = load("res://assets/smiley placeholder.png")
	resize_button_tr.anchor_left = 1.0
	resize_button_tr.anchor_right = 1.0
	resize_button_tr.offset_left = - resize_button_tr.icon.get_size().x / 2 - margin_size
	resize_button_tr.offset_top = - resize_button_tr.icon.get_size().y / 2 - margin_size
	resize_button_tr.flat = true
	resize_button_tr.gui_input.connect(on_resize_button_tr_clicked)
	self.add_child(resize_button_tr)
	
	var resize_button_bl = Button.new()
	resize_button_bl.name = "ResizeButtonBottomLeft"
	resize_button_bl.icon = load("res://assets/smiley placeholder.png")
	resize_button_bl.anchor_top = 1.0
	resize_button_bl.anchor_bottom = 1.0
	resize_button_bl.offset_left = - resize_button_bl.icon.get_size().x / 2 - margin_size
	resize_button_bl.offset_top = - resize_button_bl.icon.get_size().y / 2 - margin_size
	resize_button_bl.flat = true
	resize_button_bl.gui_input.connect(on_resize_button_bl_clicked)
	self.add_child(resize_button_bl)
	
	var resize_button_br = Button.new()
	resize_button_br.name = "ResizeButtonBottomRight"
	resize_button_br.icon = load("res://assets/smiley placeholder.png")
	resize_button_br.anchor_top = 1.0
	resize_button_br.anchor_bottom = 1.0
	resize_button_br.anchor_left = 1.0
	resize_button_br.anchor_right = 1.0
	resize_button_br.offset_left = - resize_button_br.icon.get_size().x / 2 - margin_size
	resize_button_br.offset_top = - resize_button_br.icon.get_size().y / 2 - margin_size
	resize_button_br.flat = true
	resize_button_br.gui_input.connect(on_resize_button_br_clicked)
	self.add_child(resize_button_br)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if not resizing == "null":
		resize_difference = get_viewport().get_mouse_position() - original_corner_position
		#print(resize_difference)
	
	match resizing:
		"null":
			pass
		"tl":
			pass
		"tr":
			pass
		"bl":
			pass
		"br":
			pass

func on_resize_button_tl_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("resize button tl clicked")
			resizing = "tl"
			resize_difference = Vector2.ZERO
			original_corner_position = get_viewport().get_mouse_position()
			parent_original_size = get_parent().info["size"]
			parent_original_position = get_parent().global_position
			
		elif event.is_released():
			resizing = "null"
	
func on_resize_button_tr_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("resize button tr clicked")
			resizing = "tr"
			resize_difference = Vector2.ZERO
			original_corner_position = get_viewport().get_mouse_position()
			parent_original_size = get_parent().info["size"]
			parent_original_position = get_parent().global_position
			
		elif event.is_released():
			resizing = "null"
	
func on_resize_button_bl_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("resize button bl clicked")
			resizing = "bl"
			resize_difference = Vector2.ZERO
			original_corner_position = get_viewport().get_mouse_position()
			parent_original_size = get_parent().info["size"]
			parent_original_position = get_parent().global_position
		elif event.is_released():
			resizing = "null"
	
func on_resize_button_br_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("resize button br clicked")
			resizing = "br"
			resize_difference = Vector2.ZERO
			original_corner_position = get_viewport().get_mouse_position()
			parent_original_size = get_parent().info["size"]
			parent_original_position = get_parent().global_position
		elif event.is_released():
			resizing = "null"
