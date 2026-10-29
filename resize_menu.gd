class_name ResizeMenu
extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# creating and adding all buttons
	var resize_button_tl = Button.new()
	resize_button_tl.name = "ResizeButtonTopLeft"
	resize_button_tl.gui_input.connect(on_resize_button_tl_clicked)
	self.add_child(resize_button_tl)
	
	var resize_button_tr = Button.new()
	resize_button_tr.name = "ResizeButtonTopRight"
	resize_button_tr.gui_input.connect(on_resize_button_tr_clicked)
	self.add_child(resize_button_tr)
	
	var resize_button_bl = Button.new()
	resize_button_bl.name = "ResizeButtonBottomLeft"
	resize_button_bl.gui_input.connect(on_resize_button_bl_clicked)
	self.add_child(resize_button_bl)
	
	var resize_button_br = Button.new()
	resize_button_br.name = "ResizeButtonBottomRight"
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
