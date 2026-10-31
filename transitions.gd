extends CanvasLayer

@onready var loading_screen = get_tree().root.find_child("LoadingScreen", true, false)

var transition_speed = 0.25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#loading_screen.self_modulate.a = 0.0
	#loading_screen.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_scene(scene_path: String) -> void:
	loading_screen.show()
	loading_screen.self_modulate.a = 0.0
	
	var tween_in = get_tree().create_tween()
	tween_in.tween_property(loading_screen, "self_modulate:a", 1.0, transition_speed)
	
	# tweens are asynchronous
	await tween_in.finished
	get_tree().change_scene_to_file(scene_path)
	
	var tween_out = get_tree().create_tween()
	tween_out.tween_property(loading_screen, "self_modulate:a", 0.0, transition_speed)
	
	await tween_out.finished
	loading_screen.hide()
