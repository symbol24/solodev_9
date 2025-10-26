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

# GAME MANAGER
signal start_level
signal start_countdown
signal start_run
signal timer_updated(string_time:String)

# UI
signal toggle_screen(id:StringName, display:bool)

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


# ENEMIES
signal enemy_defeated
