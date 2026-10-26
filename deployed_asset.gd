class_name DeployedAsset
extends TextureRect

var hash_chars := "0123456789abcdef"

var info = {
	uuid = "null",
	type = "null",
	image_path = "null",
	details = "null"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create(type: String, image_path: String, index: int):
	var txt_file_path = "res://assets/" + str(type) + "s/descriptions/" + str(type) + "_descriptions.txt"
	#print(txt_file_path)
	var file = FileAccess.open(txt_file_path, FileAccess.READ)
	var description
	
	info["uuid"] = generate_uuid()
	info["type"] = type
	info["image_path"] = image_path
	
	for i in range(index + 1):
		description = file.get_line()
	
	info["details"] = description
	print(info["uuid"])
	print(info["details"])
	print("")

# UUID follows an 8-4-4-4-12 hex-and dash format
func generate_uuid() -> String:
	randomize() # reset seed of pseudo-rangom number generator
	var uuid:String
	var section_lengths = [8, 4, 4, 4, 12]
	
	for i in section_lengths:
		for j in range(i):
			uuid += hash_chars[randi_range(0, 15)] # randi_range is inclusive of both ends
		uuid += "-"
		
	uuid = uuid.trim_suffix("-") # get rid of the excess - added to the end
	
	return uuid
