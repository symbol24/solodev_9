extends Node2D


const MIN_DB := -60.0
const MAX_DB := 0.0
const DELAY := 60.0


var audio_pool:Array = []
var music:RidAudioStreamPlayer
var audio_check_timer :float = 0.0:
	set(_value):
		audio_check_timer = _value
		if audio_check_timer >= DELAY:
			audio_check_timer = 0.0
			_clear_audio_pool()


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Signals.BusVolumeUpdate.connect(_update_audio_volume)


func _process(_delta:float) -> void:
	audio_check_timer += _delta 


func _play_audio(_audio_file:AudioFile) -> RidAudioStreamPlayer:
	if _audio_file != null:
		# If the audio file is set to unique, we immediatly return the ongoing audio stream if its playing
		if _audio_file.is_unique:
			var temp:RidAudioStreamPlayer = _get_currently_playing(_audio_file)
			if temp: return temp
			
		# Used for music to fade between old and new music.
		var fade := false
		var out_music:RidAudioStreamPlayer
		var in_db:float = -10
		
		var new_player:RidAudioStreamPlayer = RidAudioStreamPlayer.new()
		new_player.name = _audio_file.id
		add_child(new_player)
		audio_pool.append(new_player)
		new_player.process_mode = Node.PROCESS_MODE_ALWAYS if _audio_file.play_when_paused else Node.PROCESS_MODE_PAUSABLE
		
		# If music 
		if _audio_file.track == Data.Track.MUSIC:
			# If music already playing
			if music != null:
				print(music.name, " is playing")
				out_music = music
				fade = true
				in_db = _audio_file.volume_db

			music = new_player
		
			# Trigger music fade
			if fade: 
				music.volume_db = MIN_DB
				_fade_music(out_music, music, in_db)

		new_player.name = _audio_file.id
		if new_player: new_player.play()

		return new_player
	else:
		push_warning("Pay_Audio is receiving a null value.")
		return null


func _get_track(value:Data.Track) -> StringName:
	match value:
		Data.Track.MUSIC:
			return &"Music"
		Data.Track.SFX:
			return &"SFX"
		_:
			return &"Master"


func _load_complete() -> void:
	_set_all_bus_volumes(Data.active_data)


func _set_all_bus_volumes(player_data:PlayerData) -> void:
	if player_data == null:
		push_warning("No player data for Audio settings")
		return
	_update_audio_volume("Master", player_data.master_volume)
	_update_audio_volume("Music", player_data.music_volume)
	_update_audio_volume("SFX", player_data.sfx)


func _update_audio_volume(bus_name :StringName = "Master", percent :float = 1.0) -> void:
	if percent > -0.1 and percent <= 1.0:
		var bus_index:int = AudioServer.get_bus_index(bus_name)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(percent))


func _fade_music(_out:RidAudioStreamPlayer, _in:RidAudioStreamPlayer, _max_db_of_in:float) -> void:
	var tween:Tween = create_tween()
	tween.tween_property(_out, "volume_db", MIN_DB, 1.0)
	tween.parallel()
	tween.tween_property(_in, "volume_db", _max_db_of_in, 1.0)
	tween.finished.connect(_out.exit_tree)


func _clear_audio_pool() -> void:
	var x :int = 0
	var to_clear :Array = []
	while x < audio_pool.size():
		if audio_pool[x] != null and !audio_pool[x].playing:
			to_clear.append(x)
		x += 1
	if not to_clear.is_empty():
		for i:int in to_clear:
			if i < audio_pool.size():
				var temp:Node = audio_pool.pop_at(i)
				if temp != null:
					temp.queue_free.call_deferred()


func _freed_audio(_audio:Node) -> void:
	var x :int = 0
	var found :bool = false
	while x < audio_pool.size():
		if _audio == audio_pool[x]:
			found = true
			break
		x += 1
	if found:
		var _temp:Node = audio_pool.pop_at(x)
		remove_child(_temp)
		_temp.queue_free.call_deferred()


func _get_currently_playing(_audio_file:AudioFile = null) -> Node:
	for each:Node in audio_pool:
		if each != null and each.audio_file == _audio_file and each.is_playing():
			return each
	return null
