extends Node2D


enum Track {MASTER, MUSIC, SFX}
enum Damage_Types {WHITE = 0, BLACK = 1}


const FOLDER := "user://save/"
const SAVEFILE := "save.tres"
const SCENES := preload("uid://de8l0dctnt31x")
const EXTRA_LOAD_TIME := 3.0
const PLAYER_CHARACTER_DATA := "uid://b7663288ccnba"
const WHITE:Color = Color("cfcfcfff")
const BLACK:Color = Color("131313ff")
const FLOOR_SPRITE_PATH := "uid://cvxlr7njyheqi"


var player_character_data:PlayerCharacterData = null:
	get:
		if player_character_data == null: player_character_data = load(PLAYER_CHARACTER_DATA)
		return player_character_data
var active_data:PlayerData = null


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Signals.input_type_changed.connect(_update_input_type)


func save() -> void:
	if active_data == null:
		active_data = PlayerData.new()
	
	# TODO: Place whatever information you want in the SaveData
	# or retrieve the data you want and add it to the save
	
	active_data.save_time_and_date = Time.get_unix_time_from_system()
	var result := ResourceSaver.save(active_data, FOLDER + SAVEFILE)
	if result == OK:
		Signals.save_complete.emit()
	else:
		push_warning("Save error: ", error_string(result))


func load() -> bool:
	var dir:DirAccess = _check_folder()
	if dir != null and dir.file_exists(FOLDER + SAVEFILE):
		active_data = load(FOLDER + SAVEFILE)
		Signals.load_complete.emit()
		return true
	return false


func _check_folder() -> DirAccess:
	var dir:DirAccess = DirAccess.open(FOLDER)
	if dir == null:
		var result = DirAccess.make_dir_absolute(FOLDER)
		if result != OK:
			print_debug("Error creating save folder: ", result)
			return null
	return dir


func _update_input_type(value:InputManager.Type) -> void:
	active_data.input_type = value
	print("Input now: ", InputManager.Type.keys()[active_data.input_type])
