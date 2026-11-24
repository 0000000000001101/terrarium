extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(on_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_button_pressed() -> void:
	var sub_viewport = SubViewport.new()
	
	get_tree().root.add_child(sub_viewport)
	
	sub_viewport.world_2d = get_viewport().world_2d
	
	sub_viewport.size = Vector2(get_viewport().get_visible_rect().size.x - 310, get_viewport().get_visible_rect().size.y)
	
	# Hardcoded to move 320 , so does not yet adapt well to various 
	# The reason it's negative is because this moves the world in relation to the [sub]viewport, not the viewport in relation to the world.
	sub_viewport.canvas_transform = Transform2D(0.0, Vector2(- 310, 0))
	
	#sub_viewport.canvas_transform.origin = Vector2(-300, 0)
	
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	
	# hide the screenshot button so it does not show up in the screenshot
	get_tree().root.find_child("ScreenshotButton", true, false).hide()
	
	# await for a frame to process (waiting for the screenshot button to be hidden)
	await RenderingServer.frame_post_draw
	
	var img = sub_viewport.get_texture().get_image()
	
	var pictures_dir := OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS)

	var file_name := "screenshot_%s.png" % Time.get_datetime_string_from_system().replace(":", "-")
	var full_path := pictures_dir.path_join(file_name)

	var err := img.save_png(full_path)
	if err == OK:
		print("Saved screenshot to: ", full_path)
	else:
		push_error("Failed to save screenshot (error %s) to %s" % [err, full_path])
	
	img.save_png("res://screenshot.png")
	sub_viewport.queue_free()
	print("screenshotted")

	#testing showing a screenshotted success message or image or so
	var screenshot_message = get_tree().root.find_child("ScreenshotMessage", true, false)
	screenshot_message.show()
	
	var tween = get_tree().create_tween()
	tween.tween_property(screenshot_message, "self_modulate:a", 1.0, 0.25)
	tween.tween_property(screenshot_message, "self_modulate:a", 0.0, 0.25)
	
	tween.finished.connect(func(): 
		screenshot_message.hide()
	)
	
	await tween.finished
	await RenderingServer.frame_post_draw
	
	# reshow the screenshot button
	get_tree().root.find_child("ScreenshotButton", true, false).show()
