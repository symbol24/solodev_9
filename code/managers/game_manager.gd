class_name GameManager extends Node


var _run_timer:float = 0.0:
	set(value):
		_run_timer = value
		Signals.timer_updated.emit(_get_time_as_string(_run_timer))
var _level:Level = null:
	get:
		if _level == null or not is_instance_valid(_level): _level = get_tree().get_first_node_in_group(&"level")
		return _level
var _run_active := false
var _enemy_spawn_complete := false
var _no_more_enemies := false
var _run_result := false
var _current_round_count := 0


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Signals.start_run.connect(_start_run)
	Signals.enemy_waves_complete.connect(_enemy_waves_complete)
	Signals.all_enemies_killed.connect(_all_enemies_killed)
	Signals.character_is_full_dead.connect(_character_full_dead)
	Signals.request_round_count.connect(_send_round_number)
	Signals.request_run_result.connect(_send_run_result)
	Signals.toggle_pause.connect(_toggle_pause)
	Signals.start_round.connect(_start_next_round)


func _process(delta: float) -> void:
	if _run_active: _run_timer += delta


func _start_run() -> void:
	_run_active = false
	_run_timer = 0.0
	_enemy_spawn_complete = false
	_no_more_enemies = false
	_current_round_count = 0


func _start_next_round() -> void:
	_current_round_count += 1
	_toggle_pause(false)
	#Signals.next_round_started.emit(_current_round_count)


func _enemy_waves_complete() -> void:
	_enemy_spawn_complete = true


func _all_enemies_killed() -> void:
	_no_more_enemies = true
	_end_round(true)


func _get_time_as_string(_timer:float) -> String:
	var msec := fmod(_timer, 1) * 1000
	var sec := fmod(_timer, 60)
	var mins := fmod(_timer, 3600) / 60
	return "%02d:%02d.%03d" % [mins, sec, msec]


func _character_full_dead() -> void:
	_end_round(false)


func _end_round(success:bool = false) -> void:
	_run_active = false
	if not success:
		_end_run(success)
	else:
		_toggle_pause(true)
		if _current_round_count >= _level.round_count: _end_run(success)
		else: Signals.toggle_screen.emit(&"round_screen", true)
		

func _end_run(success:bool = false) -> void:
	_toggle_pause(true)
	_run_result = success
	Signals.toggle_screen.emit(&"run_screen", true)


func _send_round_number() -> void:
	Signals.round_count.emit(_current_round_count)


func _send_run_result() -> void:
	Signals.run_result.emit(_run_result)


func _toggle_pause(value:bool) -> void:
	_run_active = !value
	get_tree().paused = value
