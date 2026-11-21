extends MenuButton

const THEMES = {
	0: "res://themes/main_theme.tres",
	1: "res://themes/catppuccin-mocha.tres",
	2: "res://themes/catppuccin-macchiato.tres",
	3: "res://themes/catppuccin-frappé.tres",
	4: "res://themes/catppuccin-latte.tres",
	5: "res://themes/dark-electric-pink.tres",
	6: "res://themes/fox-friend.tres",
	7: "res://themes/wolf-kami.tres",
	8: "res://themes/rice-pudding.tres",
	9: "res://themes/inu.tres"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_popup().id_pressed.connect(_on_theme_selected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_theme_selected(id: int) -> void:
	if THEMES.has(id):
		var theme_path = THEMES[id]
		var new_theme = load(theme_path) as Theme
		if new_theme:
			var root_node = get_node("/root/Terrarium")
			if root_node:
				root_node.theme = new_theme
				print("Switched theme to: ", theme_path)
