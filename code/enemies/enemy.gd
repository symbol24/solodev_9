class_name Enemy extends Entity


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE


var _target:Character = null:
	get:
		if _target == null: _target = get_tree().get_first_node_in_group(&"player")
		return _target

@onready var attack_area: AttackArea = %attack_area
@onready var outline: Sprite2D = %outline


func _process(delta: float) -> void:
	if _is_active:
		velocity = _move_to_target(velocity, delta)
		move_and_slide()

		if not _damage_pool.is_empty() and not _applying_damage:
			_apply_damage()


func setup_character(new_data:EnemyData) -> void:
	_data = new_data.duplicate(true)
	_data.setup_character()
	_setup_attack()
	sprite.texture = _data.texture
	sprite.modulate = _data.get_color()
	outline.texture = _data.oultine
	outline.modulate = Data.BLACK if is_white else Data.WHITE
	_is_active = true


func get_imune_time() -> float:
	return _data.imune_time


func _apply_damage() -> void:
	_applying_damage = true
	var is_dead := _data.apply_damage(_damage_pool.pop_front(), Damage.Types.WHITE if is_white else Damage.Types.BLACK)
	if is_dead: _die()
	_applying_damage = false


func _die() -> void:
	var is_full_dead := _data.die()
	if is_full_dead:
		_is_active = false
		Signals.enemy_defeated.emit()
		queue_free.call_deferred()


func _move_to_target(current:Vector2, delta:float) -> Vector2:
	var direction := global_position.direction_to(_target.global_position)
	direction = direction.normalized()
	var x:float = move_toward(current.x, direction.x * _data.speed, delta * CharacterData.ACCELERATION)
	var y:float = move_toward(current.y, direction.y * _data.speed, delta * CharacterData.ACCELERATION)
	return Vector2(x, y)


func _setup_attack() -> void:
	if _data.contact_damage != null:
		var attack_data := AttackData.new()
		attack_data.damage = _data.contact_damage
		attack_data.set_new_owner(_data)
		attack_area.setup_attack(attack_data)
