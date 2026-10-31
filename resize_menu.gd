class_name ResizeMenu
extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# creating and adding all buttons
	var resize_button_tl = Button.new()
	resize_button_tl.name = "ResizeButtonTopLeft"
	resize_button_tl.icon = load("res://assets/smiley placeholder.png")
	resize_button_tl.offset_left = - resize_button_tl.icon.get_size().x / 2
	resize_button_tl.offset_top = - resize_button_tl.icon.get_size().y / 2
	resize_button_tl.flat = true
	resize_button_tl.gui_input.connect(on_resize_button_tl_clicked)
	self.add_child(resize_button_tl)
	
	var resize_button_tr = Button.new()
	resize_button_tr.name = "ResizeButtonTopRight"
	resize_button_tr.icon = load("res://assets/smiley placeholder.png")
	resize_button_tr.anchor_left = 1.0
	resize_button_tl.offset_right = resize_button_tl.icon.get_size().x / 2
	resize_button_tl.offset_top = - resize_button_tl.icon.get_size().y / 2
	resize_button_tr.flat = true
	resize_button_tr.gui_input.connect(on_resize_button_tr_clicked)
	self.add_child(resize_button_tr)
	
	var resize_button_bl = Button.new()
	resize_button_bl.name = "ResizeButtonBottomLeft"
	resize_button_bl.icon = load("res://assets/smiley placeholder.png")
	resize_button_bl.flat = true
	resize_button_bl.gui_input.connect(on_resize_button_bl_clicked)
	self.add_child(resize_button_bl)
	
	var resize_button_br = Button.new()
	resize_button_br.name = "ResizeButtonBottomRight"
	resize_button_br.icon = load("res://assets/smiley placeholder.png")
	resize_button_br.flat = true
	resize_button_br.gui_input.connect(on_resize_button_br_clicked)
	self.add_child(resize_button_br)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_resize_button_tl_clicked(event: InputEvent) -> void:
	print("resize button tl clicked")
	
func on_resize_button_tr_clicked(event: InputEvent) -> void:
	print("resize button tr clicked")
	
func on_resize_button_bl_clicked(event: InputEvent) -> void:
	print("resize button bl clicked")
	
func on_resize_button_br_clicked(event: InputEvent) -> void:
	print("resize button br clicked")
