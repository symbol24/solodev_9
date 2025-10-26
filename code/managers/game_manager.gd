class_name GameManager extends Node


var _run_timer:float = 0.0:
	set(value):
		_run_timer = value
		Signals.timer_updated.emit(_get_time_as_string(_run_timer))
var _run_active := false
var _enemy_spawn_complete := false
var _no_more_enemies := false


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Signals.start_run.connect(_start_run)
	Signals.enemy_waves_complete.connect(_enemy_waves_complete)
	Signals.all_enemies_killed.connect(_all_enemies_killed)


func _process(delta: float) -> void:
	if _run_active: _run_timer += delta


func _start_run() -> void:
	_run_timer = 0.0
	_enemy_spawn_complete = false
	_run_active = true


func _stop_run() -> void:
	_run_active = false


func _enemy_waves_complete() -> void:
	_enemy_spawn_complete = true


func _all_enemies_killed() -> void:
	_no_more_enemies = true


func _get_time_as_string(_timer:float) -> String:
	var msec := fmod(_timer, 1) * 1000
	var sec := fmod(_timer, 60)
	var mins := fmod(_timer, 3600) / 60
	return "%02d:%02d.%03d" % [mins, sec, msec]
