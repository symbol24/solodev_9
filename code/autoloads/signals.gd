extends Node


# DATA
signal save_complete
signal load_complete

# AUDIO
signal play_audio(audio_file:AudioFile)
signal VolumesUpdated
signal BusVolumeUpdate(bus:String, value:float)

# SCENE MANAGER
signal load_scene(id:StringName, loading_screen:bool, extra_time:bool)
signal level_ready
signal unload_level

# GAME MANAGER
signal start_level
signal start_countdown
signal start_run
signal timer_updated(string_time:String)
signal start_next_round
signal run_result(success:bool)
signal round_count(round:int)
signal toggle_pause(value:bool)
signal start_round

# UI
signal toggle_screen(id:StringName, display:bool)
signal request_run_result
signal request_round_count

# INPUTS
signal input_change_focus(id:StringName, is_focused:bool)
signal input_focuse_changed
signal input_type_changed(type:InputManager.Type)
signal register_process(process:InputProcess)
signal unregister_input_process()

# SPAWN MANAGER
signal spawn_character(data:PlayerCharacterData, pos:Vector2)
signal enemy_waves_complete
signal all_enemies_killed

# FLOOR MANAGER
signal toggle_ground_color(color:Color)

# CHARACTER
signal character_spawned(character:Character)
signal character_data_ready(character_data:PlayerCharacterData)
signal character_hp_updated
signal character_lives_updated
signal character_is_full_dead
signal refocus_input

# ENEMIES
signal enemy_defeated
