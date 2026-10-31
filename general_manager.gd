extends Node

const CANVAS_SCENE_PATH := "res://scenes/canvas.tscn"
var glass_selected := 0
var glass_path: String

# pattern is "Glass" followed by anything
@onready var glass1 = get_tree().root.find_child("Glass1", true, false)
@onready var glass2 = get_tree().root.find_child("Glass2", true, false)
@onready var glass3 = get_tree().root.find_child("Glass3", true, false)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if glass1 and glass2 and glass3: # won't run if running only the canvas.tscn
		glass1.pressed.connect(on_glass1_selected)
		glass2.pressed.connect(on_glass2_selected)
		glass3.pressed.connect(on_glass3_selected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_glass1_selected() -> void:
	print("glass 1 pressed")
	glass_selected = 1
	glass_path = glass1.texture_normal.get_path()
	print(glass_path)
	change_scene_to_canvas()
	#var scene2_path = load(CANVAS_SCENE_PATH)
	#if scene2_path:
		#var scene2 = scene2_path.instantiate()
		#add_child(scene2)
	#else:
		#print("could not load " + CANVAS_SCENE_PATH)

func on_glass2_selected() -> void:
	print("glass 2 pressed")
	glass_selected = 2
	glass_path = glass2.texture_normal.get_path()
	change_scene_to_canvas()
	
func on_glass3_selected() -> void:
	print("glass 3 pressed")
	glass_selected = 3
	glass_path = glass3.texture_normal.get_path()
	change_scene_to_canvas()

func change_scene_to_canvas() -> void:
	Transitions.change_scene(CANVAS_SCENE_PATH)
