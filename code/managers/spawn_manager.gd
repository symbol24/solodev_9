class_name SpawnManager extends Node2D


const ENEMY_SPAWN_INTERVAL := 0.15
const MIN_DISTANCE := 300.0
const X := 320.0
const Y := 170.0


var _level:Level = null:
	get:
		if _level == null: _level = get_tree().get_first_node_in_group(&"level")
		return _level
var _player:Character = null:
	get:
		if _player == null: _player = get_tree().get_first_node_in_group(&"player")
		return _player
var _current_wave := 0
var _total_kills := 0
var _total_enemies := 0


func _ready() -> void:
	Signals.spawn_character.connect(_spawn_character)
	Signals.start_run.connect(_start_run)
	Signals.enemy_defeated.connect(_enemy_killed)


func _spawn_character(data:CharacterData, _position:Vector2) -> void:
	if data == null: return
	if data.path == "": return

	var new_character = load(data.path).instantiate()
	add_child(new_character)
	new_character.name = data.id + &"0"
	new_character.global_position = _position
	new_character.setup_character(data)


func _start_run() -> void:
	await get_tree().create_timer(0.4).timeout
	_total_enemies = _get_enemy_count()
	_spawn_enemies(_current_wave)


func _spawn_enemies(current_wave:int = 0) -> void:
	if not _level.enemy_waves.has(current_wave): 
		Signals.enemy_waves_complete.emit()
		return
	for y in _level.enemy_waves[current_wave][&"wave_count"]:
		for j in _level.enemy_waves[current_wave][&"spawn_per_wave"]:
			_spawn_character(_level.enemy_waves[current_wave][&"data"], _get_random_position())
			await get_tree().create_timer(ENEMY_SPAWN_INTERVAL).timeout
		await get_tree().create_timer(_level.enemy_waves[current_wave][&"interval"]).timeout
	
	_current_wave += 1
	_spawn_enemies(_current_wave)


func _get_random_position() -> Vector2:
	var distance := 0.0
	var top_left := Vector2(_player.global_position.x - X, _player.global_position.y - Y)
	var bottom_right := Vector2(_player.global_position.x + X, _player.global_position.y + Y)
	var point:Vector2
	var count := 0
	while distance < MIN_DISTANCE:
		point = Vector2(randi_range(top_left.x, bottom_right.x), randi_range(top_left.y, bottom_right.y))
		distance = point.distance_squared_to(_player.global_position)
		count += 1
		if count >= 50: break
	return point


func _get_enemy_count() -> int:
	var total := 0
	for k in _level.enemy_waves.keys():
		total += _level.enemy_waves[k][&"wave_count"] * _level.enemy_waves[k][&"spawn_per_wave"]

	return total


func _enemy_killed() -> void:
	_total_kills += 1
	if _total_kills >= _total_enemies:
		Signals.all_enemies_killed.emit()
