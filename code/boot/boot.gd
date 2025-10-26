class_name Boot extends Node2D


var _loading := false
var _load_complete := false
var _loading_status:ResourceLoader.ThreadLoadStatus
var _progress := []
var _intros_done := false
var _current_loading := &"scene_manager"


func _input(_event: InputEvent) -> void:
	if Input.is_anything_pressed():
		_transfer_to()


func _ready() -> void:
	if not Data.load(): Data.save()
	_load()
	await get_tree().create_timer(0.5).timeout
	_intros_done = true


func _process(_delta: float) -> void:
	if _loading:
		_loading_status = ResourceLoader.load_threaded_get_status(Data.SCENES.list[_current_loading], _progress)
		#print("loading ", _current_loading , ": ", _progress[0]*100, "%")
		if _loading_status == ResourceLoader.THREAD_LOAD_LOADED:
			if not _load_complete:
				_load_complete = true
				_complete_load()


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
