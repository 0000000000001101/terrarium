extends CanvasLayer

@onready var loading_screen = get_tree().root.find_child("LoadingScreen", true, false)

var transition_speed = 0.25
var second_transition_speed = 0.2

const INVENTORY_SCENE = preload("res://scenes/inventory_dupe.tscn")
@onready var inventory: Control = INVENTORY_SCENE.instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#loading_screen.self_modulate.a = 0.0
	#loading_screen.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_scene_1(scene_path: String) -> void:
	loading_screen.show()
	loading_screen.self_modulate.a = 0.0
	
	var tween_in = get_tree().create_tween().set_parallel(true)
	tween_in.tween_property(loading_screen, "self_modulate:a", 1.0, transition_speed)
	
	# I want to try to tween in the inventory
	load_inventory()
	
	# tweens are asynchronous
	await tween_in.finished
	get_tree().change_scene_to_file(scene_path)
	
	var tween_out = get_tree().create_tween().set_parallel(true)
	tween_out.tween_property(loading_screen, "self_modulate:a", 0.0, transition_speed)
	
	await tween_out.finished
	loading_screen.hide()
	
func load_inventory() -> void:
	# disconnecting the script
	inventory.set_script(null)
	
	add_child(inventory)
	inventory.theme = load("res://themes/main_theme.tres") as Theme
	inventory.scale.x = 0.0
	inventory.modulate.a = 0.0
	
	await get_tree().process_frame
	
	inventory.show()
	inventory.z_index = 1000
	
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(inventory, "modulate:a", 1.0, transition_speed * 2).from(0.0)
	tween.parallel().tween_property(inventory, "scale:x", 1.01, transition_speed).from(0.0)
	tween.tween_property(inventory, "modulate:a", 0.0, transition_speed + 0.1).from(1.0)
	
	tween.finished.connect(func():
		inventory.hide()
		inventory.get_parent().remove_child(inventory)
		inventory.queue_free()
	)
	
	#await tween.finished

func change_scene_2(scene_path: String) -> void:
	loading_screen.show()
	loading_screen.self_modulate.a = 0.0
	
	var tween_in = get_tree().create_tween().set_parallel(true)
	tween_in.tween_property(loading_screen, "self_modulate:a", 1.0, transition_speed)
	
	# tweens are asynchronous
	await tween_in.finished
	get_tree().change_scene_to_file(scene_path)
	
	var tween_out = get_tree().create_tween().set_parallel(true)
	tween_out.tween_property(loading_screen, "self_modulate:a", 0.0, transition_speed)
	
	await tween_out.finished
	loading_screen.hide()
