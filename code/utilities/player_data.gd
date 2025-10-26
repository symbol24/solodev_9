class_name PlayerData extends Resource


@export var id := &"solodev_9_halloween"

@export var master_volume := 1.0:
	set(value):
		master_volume = clampf(value, 0.0, 1.0)
@export var music_volume := 1.0:
	set(value):
		music_volume = clampf(value, 0.0, 1.0)
@export var sfx_volume := 1.0:
	set(value):
		sfx_volume = clampf(value, 0.0, 1.0)

var default_master := 1.0
var default_music := 1.0
var default_sfx := 1.0

@export var input_type:InputManager.Type
@export var save_time_and_date:float