extends Node

const CANVAS_SCENE_PATH := "res://scenes/canvas.tscn"
const GLASS_SCENE_PATH := "res://scenes/glass_selection_screen.tscn"
var glass_selected := 0
var glass_path: String

var skip_server_connection := false

@onready var glass1 = get_tree().root.find_child("Glass1", true, false)
@onready var glass2 = get_tree().root.find_child("Glass2", true, false)
@onready var glass3 = get_tree().root.find_child("Glass3", true, false)

@onready var server_connect_button = get_tree().root.find_child("ServerConnectButton", true, false)
@onready var skip_server_button = get_tree().root.find_child("SkipServerButton", true, false)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if server_connect_button and skip_server_button:
		server_connect_button.pivot_offset = server_connect_button.size / 2
		server_connect_button.button_down.connect(_on_server_connect_button_down)
		server_connect_button.button_up.connect(_on_server_connect_button_up)
		
		skip_server_button.pivot_offset = skip_server_button.size / 2
		skip_server_button.button_down.connect(_on_skip_server_button_down)
		skip_server_button.button_up.connect(_on_skip_server_button_up)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_glass1_button_down() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(glass1, "scale", Vector2(1.2, 1.2), 0.05).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(func():
		print("tween finished")
		glass_selected = 1
		glass_path = "res://assets/glass/glass jar 1.png"
	)
	
func _on_glass1_button_up() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(glass1, "scale", Vector2.ONE, 0.05).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(func():
		change_scene_to_canvas()
	)
	
func _on_glass2_button_down() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(glass2, "scale", Vector2(1.2, 1.2), 0.05).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(func():
		print("tween finished")
		glass_selected = 2
		glass_path = "res://assets/glass/glass jar 2.png"
	)
	
func _on_glass2_button_up() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(glass2, "scale", Vector2.ONE, 0.05).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(func():
		change_scene_to_canvas()
	)
	
func _on_glass3_button_down() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(glass3, "scale", Vector2(1.2, 1.2), 0.05).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(func():
		print("tween finished")
		glass_selected = 3
		glass_path = "res://assets/glass/glass jar 3.png"
	)
	
func _on_glass3_button_up() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(glass3, "scale", Vector2.ONE, 0.05).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(func():
		change_scene_to_canvas()
	)

func _on_server_connect_button_down() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(server_connect_button, "scale", Vector2(1.2, 1.2), 0.05).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	
func _on_server_connect_button_up() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(server_connect_button, "scale", Vector2.ONE, 0.05).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(func():
		change_scene_to_glass()
	)
	
func _on_skip_server_button_down() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(skip_server_button, "scale", Vector2(1.2, 1.2), 0.05).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(func():
		skip_server_connection = true
	)
	
func _on_skip_server_button_up() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(skip_server_button, "scale", Vector2.ONE, 0.05).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(func():
		change_scene_to_glass()
	)

func change_scene_to_canvas() -> void:
	Transitions.change_scene_1(CANVAS_SCENE_PATH)

func change_scene_to_glass() -> void:
	await Transitions.change_scene_2(GLASS_SCENE_PATH)
	await get_tree().process_frame
	
	glass1 = get_tree().root.find_child("Glass1", true, false)
	glass2 = get_tree().root.find_child("Glass2", true, false)
	glass3 = get_tree().root.find_child("Glass3", true, false)
	
	if glass1 and glass2 and glass3: # won't run if running only the canvas.tscn
		glass1.pivot_offset = glass1.size / 2
		glass1.button_down.connect(_on_glass1_button_down)
		glass1.button_up.connect(_on_glass1_button_up)
		
		glass2.pivot_offset = glass2.size / 2
		glass2.button_down.connect(_on_glass2_button_down)
		glass2.button_up.connect(_on_glass2_button_up)
		
		glass3.pivot_offset = glass3.size / 2
		glass3.button_down.connect(_on_glass3_button_down)
		glass3.button_up.connect(_on_glass3_button_up)
