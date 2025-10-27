class_name Boot extends Node2D


var _loading := false
var _load_complete := false
var _loading_status:ResourceLoader.ThreadLoadStatus
var _progress := []
var _intros_done := false
var _current_loading := &"scene_manager"
var _current_anim := &""
var _next_anim := &""
var _done_anim := false
var _can_input := true

@onready var anim_player: AnimationPlayer = %anim_player


func _input(_event: InputEvent) -> void:
	if Input.is_anything_pressed() and _can_input:
		_can_input = false
		anim_player.stop()
		_play_anim(_current_anim)
		get_tree().create_timer(0.2).timeout.connect(_reset_can_input)


func _ready() -> void:
	anim_player.animation_finished.connect(_play_anim)
	if not Data.load(): Data.save()
	_load()
	await get_tree().create_timer(0.5).timeout
	_intros_done = true
	_play_anim(_current_anim)


func _process(_delta: float) -> void:
	if _loading:
		_loading_status = ResourceLoader.load_threaded_get_status(Data.SCENES.list[_current_loading], _progress)
		#print("loading ", _current_loading , ": ", _progress[0]*100, "%")
		if _loading_status == ResourceLoader.THREAD_LOAD_LOADED:
			if not _load_complete:
				_load_complete = true
				_complete_load()


func _play_anim(anim_name) -> void:
	match anim_name:
		&"godot":
			_current_anim = &"RESET"
			_next_anim = &"logo"
		&"logo":
			_current_anim = &"RESET"
			_next_anim = &"warning"
		&"warning":
			_done_anim = true
			_current_anim = &""
			_transfer_to()
		&"RESET":
			_current_anim = _next_anim
		_:
			if not _done_anim: _current_anim = &"godot"
	
	if _current_anim != &"": anim_player.play(_current_anim)


func _load() -> void:
	_load_complete = false
	_loading_status = ResourceLoader.ThreadLoadStatus.THREAD_LOAD_INVALID_RESOURCE
	ResourceLoader.load_threaded_request(Data.SCENES.list[_current_loading])
	_loading = true
	_loading_status = ResourceLoader.load_threaded_get_status(Data.SCENES.list[_current_loading], _progress)


func _complete_load() -> void:
	_loading = false
	get_tree().get_root().add_child(ResourceLoader.load_threaded_get(Data.SCENES.list[_current_loading]).instantiate())
	match _current_loading:
		&"scene_manager":
			_current_loading = &"game_manager"
			_load()
		&"game_manager":
			_current_loading = &"input_manager"
			_load()
		&"input_manager":
			_current_loading = &"ui"
			_load()
		_:
			pass


func _transfer_to() -> void:
	if not _intros_done or not _load_complete: return
	Signals.toggle_screen.emit(&"main_menu", true)
	queue_free()


func _reset_can_input() -> void:
	_can_input = true
