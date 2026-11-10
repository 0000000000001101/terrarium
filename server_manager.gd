extends TextureRect

var assets:Dictionary[String, DeployedAsset]

var socket = WebSocketPeer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# NOTE: Do not process until we are ready!
	set_process(false)

# NOTE: To be called when a "connect to server" button has been pressed.
# Then check for true or false before changing scenes.
# True if connected to the server, and false otherwise.
func connect_to_server(websocket_url: String) -> bool:
	print("Connecting to \"%s\"." % websocket_url)
	var error = socket.connect_to_url(websocket_url)
	
	socket.poll()
	while socket.get_ready_state() == WebSocketPeer.STATE_CONNECTING:
		socket.poll()
	
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		print("Connection succeeded!")
		set_process(true)
		# FIXME: This should only be ran when we are in the terrarium scene!!
		# Maybe it needs to be ran somewhere else?
		socket.send_text("{\"message_type\": \"request_state\"}")
		return true
	
	print("Couldn't connect to server!")
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	socket.poll()
	var state = socket.get_ready_state()
	
	# `WebSocketPeer.STATE_OPEN` means the socket is connected and ready to send and receive data.
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var packet = socket.get_packet()
			if socket.was_string_packet():
				var packet_text = packet.get_string_from_utf8()
				print("< Got text data from server: %s" % packet_text)
				handle_server_message(packet_text)
			else:
				print("< Got binary data from server: %d bytes" % packet.size())
				# TODO: Accept binary payloads.
				push_error("Can not handle binary data from server!")
	
	# `WebsSocketPeer.STATE_CLOSED` means the connection has fully closed.
	# It is now safe to stop polling.
	elif state == WebSocketPeer.STATE_CLOSED:
		# The code will be `-1` if the disconnection was not properly notified by the remote peer.
		var code = socket.get_close_code()
		print("WebSocket closed with code: %d. Clean %s" % [code, code != -1])
		set_process(false) # Stop processing.

func handle_server_message(json_payload: String) -> void:
	var json = JSON.parse_string(json_payload)
	if json == null:
		push_error("Can not parse message from server!!")
		return
	
	if json["message_type"] == "asset_created":
		create_deployed_asset(json["type"], json["image_path"], json["description"], Vector2(json["size"]["x"], json["size"]["y"]), Vector2(json["position"]["x"], json["position"]["y"]), true, json["uuid"])
	elif json["message_type"] == "asset_deleted":
		delete_deployed_asset(json["uuid"])
	elif json["message_type"] == "asset_layer_reordered":
		push_error("Don't know how to handle \"%s\" message type yet!" % json["message_type"])
	elif json["message_type"] == "asset_moved":
		move_deployed_asset(json["uuid"], Vector2(json["position"]["x"], json["position"]["y"]), Vector2(json["pivot_point"]["x"], json["pivot_point"]["y"]))
	elif json["message_type"] == "asset_resized":
		push_error("Don't know how to handle \"%s\" message type yet!" % json["message_type"])
	elif json["message_type"] == "asset_rotated":
		push_error("Don't know how to handle \"%s\" message type yet!" % json["message_type"])
	elif json["message_type"] == "request_state":
		push_error("What? Clients shouldn't be asked for state!! Report this error.")
	elif json["message_type"] == "meow":
		socket.send_text("meow :3")
	else:
		push_error("Don't know how to handle \"%s\" message type!" % json["message_type"])

func create_deployed_asset(type: String, image_path: String, description: String, size: Vector2, position: Vector2, server_command: bool = false, uuid: String = "NULL"):
	var deployable = DeployedAsset.new()
	
	deployable.texture = load(image_path)
	
	if uuid != "NULL":
		deployable.create(type, image_path, description, size, position, uuid)
	else:
		deployable.create(type, image_path, description, size, position)
		
	deployable.gui_input.connect(deployable._on_gui_input)
	
	deployable.expand_mode = deployable.EXPAND_IGNORE_SIZE
	deployable.custom_minimum_size = size
	deployable.position = position
	
	var canvas = get_tree().root.find_child("Canvas", true, false)
	canvas.add_child(deployable)
	
	# name the asset (image_name)(number of existing "image_names" there already are).
	var deployable_name = deployable.texture.resource_path.get_basename().get_file() # get name of the texture file without the file extension
		
	deployable.name = deployable_name + "_" + deployable.info["uuid"]
		
	print(deployable.name)
	
	assets[deployable.info["uuid"]] = deployable
	
	if not server_command:
		asset_created(deployable)

func delete_deployed_asset(uuid: String) -> void:
	var target = assets.get(uuid) as DeployedAsset
	target.queue_free()
	assets.erase(uuid)

func move_deployed_asset(uuid: String, position: Vector2, pivot_point: Vector2) -> void:
	var target = assets.get(uuid) as DeployedAsset
	target.position = position
	target.pivot_point = pivot_point

func glass_selected() -> void:
	var data = {
		"message_type": "glass_selected",
		"glass": GeneralManager.glass_selected
	}
	socket.send_text(JSON.stringify(data))

# client tells server an asset was made
func asset_created(deployable: DeployedAsset) -> void:
	var data = {
		"message_type": "asset_created",
		"uuid": deployable.info["uuid"],
		"type": deployable.info["type"],
		"image_path": deployable.info["image_path"],
		"description": deployable.info["description"],
		"position": {
			"x": deployable.info["position"].x,
			"y": deployable.info["position"].y
		},
		"size": { 
			"x": deployable.info["size"].x,
			"y": deployable.info["size"].y
		},
		"layer": deployable.info["layer"],
		"rotation": deployable.info["rotation"],
		"pivot_point": { 
			"x": deployable.info["pivot_point"].x,
			"y": deployable.info["pivot_point"].y
		},
	}
	socket.send_text(JSON.stringify(data))

func asset_deleted(deployable: DeployedAsset) -> void:
	var data = {
		"message_type": "asset_deleted",
		"uuid": deployable.info["uuid"]
	}
	socket.send_text(JSON.stringify(data))

func asset_moved(deployable: DeployedAsset) -> void:
	var data = {
		"message_type": "asset_moved",
		"uuid": deployable.info["uuid"],
		"position": {
			"x": deployable.info["position"].x,
			"y": deployable.info["position"].y
		},
		"pivot_point": { 
			"x": deployable.info["pivot_point"].x,
			"y": deployable.info["pivot_point"].y
		}
	}
	socket.send_text(JSON.stringify(data))

func asset_layer_reordered(deployable: DeployedAsset) -> void:
	var data = {
		"message_type": "asset_layer_reordered",
		"uuid": deployable.info["uuid"],
		"layer": deployable.info["layer"]
	}
	socket.send_text(JSON.stringify(data))

func asset_resized(deployable: DeployedAsset) -> void:
	var data = {
		"message_type": "asset_resized",
		"uuid": deployable.info["uuid"],
		"size": {
			"x": deployable.info["size"].x,
			"y": deployable.info["size"].y
		},
		"pivot_point": { 
			"x": deployable.info["pivot_point"].x,
			"y": deployable.info["pivot_point"].y
		}
	}
	socket.send_text(JSON.stringify(data))

func asset_rotated(deployable: DeployedAsset) -> void:
	var data = {
		"message_type": "asset_rotated",
		"uuid": deployable.info["uuid"],
		"rotation": deployable.info["rotation"]
	}
	socket.send_text(JSON.stringify(data))
