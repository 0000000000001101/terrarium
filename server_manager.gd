extends TextureRect

var assets:Array[DeployedAsset]

@export var websocket_url = "ws://127.0.0.1:8013"
var socket = WebSocketPeer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var err = socket.connect_to_url(websocket_url)
	# Initiate connection to the given URL
	if err == OK:
		print("Connecting to %s..." % websocket_url)
		# Wait for the socket to connect
		await get_tree().create_timer(2).timeout
		
		# Send data
		print("> Sending test packet.")
		socket.send_text("test")
	else:
		push_error("Unable to connect.")
		set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	# Data transfer and state updates will only happen when calling this function.
	socket.poll()
	
	# get_ready_state tells you what state the socket is in.
	var state = socket.get_ready_state()
	
	# `WebSocketPeer.STATE_OPEN` means the socket is connected and ready to send and receive data.
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var packet = socket.get_packet()
			if socket.was_string_packet():
				var packet_text = packet.get_string_from_utf8()
				print("< Got text data from server: %s" % packet_text)
				#json_msg = JSON(packet_text)
				#if json_msg["MessageType"] == "object created by server key":
					#ServerOnObjectCreate(json_msg)
			else:
				print("< Got binary data from server: %d bytes" % packet.size())
				
	# `WebsSocketPeer.STATE_CLOSED` means the connection has fully closed.
	# It is now safe to stop polling.
	elif state == WebSocketPeer.STATE_CLOSED:
		# The code will be `-1` if the disconnection was not properly notified by the remote peer.
		var code = socket.get_close_code()
		print("WebSocket closed with code: %d. Clean %s" % [code, code != -1])
		set_process(false) # Stop processing.

func create_deployed_asset(type: String, string_path: String, index: int, size: Vector2, position: Vector2):
	var deployable = DeployedAsset.new()
	
	deployable.texture = load(string_path)
	
	deployable.create(type, string_path, index, size, position)
	deployable.gui_input.connect(deployable._on_gui_input)
	
	deployable.expand_mode = deployable.EXPAND_IGNORE_SIZE
	deployable.custom_minimum_size = size
	deployable.position = position
	
	var canvas = get_tree().root.find_child("Canvas", true, false)
	canvas.add_child(deployable)
	
	assets.append(deployable)
	
	#object_created(deployable)

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
		"type": deployable.info["uuid"],
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
		"rotation": deployable.info["rotation"]
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

# server tells client an asset was made
func server_asset_created(jsonmsg: String):
	pass
	# {
	# 
	#
	# }
	#deployable.info["uuid"] = json["UUID"]
