extends Label

var selected := false

var y_offset
var is_at_top
var is_at_bottom

@onready var panel_container = get_tree().root.find_child("LayerPanelContainer", true, false)
@onready var scroll_box = get_tree().root.find_child("LayerScrollContainer", true, false)
@onready var layer_menu = get_tree().root.find_child("LayerMenu", true, false)

var placeholder = Label.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	self.gui_input.connect(on_gui_input)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			y_offset = get_viewport().get_mouse_position().y - global_position.y
			var start_global_position := global_position
			
			selected = true
			top_level = true # detach from parent position constraints for free [vertical] dragging
			
			global_position = start_global_position
			z_index = 300
			
			placeholder = Label.new()
			placeholder.autowrap_mode = TextServer.AUTOWRAP_WORD
			get_parent().add_child(placeholder)
			get_parent().move_child(placeholder, get_index())
			placeholder.text = text # such that it takes up the same space as the original node
			placeholder.add_theme_font_size_override("font_size", 16)
			placeholder.custom_minimum_size = size
			placeholder.modulate.a = 0.0 # make invisible / transparent
			
		elif event.is_released():
			selected = false
			top_level = false
			
			get_parent().move_child(self, placeholder.get_index())
			get_parent().remove_child(placeholder)
			placeholder.queue_free() # removes it from memory later
			
			reorder_layer_menu()
			
	elif event is InputEventMouseMotion and selected:
		
		var v_scroll = scroll_box.get_v_scroll_bar()
		v_scroll.value_changed.connect(func(value: float):
			is_at_top = is_equal_approx(value, v_scroll.min_value)
			is_at_bottom = is_equal_approx(value, v_scroll.max_value)
		)
		
		# add constraints here. make sure it doesnt go offscreen
		var new_position = get_viewport().get_mouse_position().y - y_offset
		var position_difference = new_position - self.position.y
		
		var top_bound = scroll_box.global_position.y
		var bottom_bound = scroll_box.global_position.y + scroll_box.size.y - size.y + 5.0
		
		# making sure it wont go out of panelcontainer bounds
		#if not v_scroll.visible and not (new_position < 0) and not (new_position > panel_container.size.y):
		self.position.y = clampf(new_position, top_bound - 5.0, bottom_bound)
			
		# making sure it won't go out of scrollbox bounds
		#if v_scroll.visible:
			## This changes where it is displayed in accordance to the immediate parent, not viewport
			#self.position.y = clampf(new_position, top_bound + 5.0, top_bound + v_scroll.max_value - size.y - 15.0)
			
		if get_parent().get_child_count() > 0:
			for label in get_parent().get_children():
				var edge_margin = 30.0
				var scroll_speed = 4
				if global_position.y <= top_bound + edge_margin:
					scroll_box.scroll_vertical -= scroll_speed
				elif global_position.y >= bottom_bound - edge_margin:
					scroll_box.scroll_vertical += scroll_speed
					
				if label == self or label == placeholder:
					continue
					
				if label.name != self.name:
					if position_difference < 0: # moving label up
						if self.global_position.y < label.global_position.y and placeholder.get_index() > label.get_index(): # on the coordinate sys positive goes down
							get_parent().move_child(placeholder, max(0, label.get_index()))
							break
					if position_difference > 0: # moving label down
						if self.global_position.y > label.global_position.y and placeholder.get_index() < label.get_index(): # on the coordinate sys positive goes down
							get_parent().move_child(placeholder, max(0, label.get_index()))
							break
		
func reorder_layer_menu() -> void:
	# iterate through the labels, find the asset with that name and set its z index
	var labels = get_parent().get_children()
	var index = get_tree().root.find_child("ResizeMenu", true, false).get_index() + 1
	# I want the top label to have the highest priority (which is closer to the bottom on the tree)
	var num_indices = get_tree().root.find_child("Description", true, false).get_index() + 1 - index
	
	for label in labels: # 10 as a buffer zone in case we want anything painted in below
		print("label text: " + label.text)
		#get_tree().root.find_child(label.text, true, false).z_index = 10 + labels.find(label)
		get_tree().root.find_child(label.text, true, false).get_parent().move_child(get_tree().root.find_child(label.text, true, false), index + num_indices)
		num_indices -= 1
		index += 1
	print("\n\n")
