class_name AudioFile extends Resource


@export var files:Array[AudioStream]
@export var decibles := -10.0
@export var track:Data.Track
@export var random_modulation := Vector2(0.9, 1.1)
@export var play_when_paused := false
@export var is_unique := false


func get_audio_file() -> AudioStream:
	if files.is_empty(): return null
	return files.pick_random()


func get_random_pitch() -> float:
	return randf_range(random_modulation.x, random_modulation.y)
