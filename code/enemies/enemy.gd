class_name Enemy extends Entity


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


func hurt(damage:Damage) -> void:
	var is_dead := _data.apply_damage(damage, Data.Damage_Types.WHITE if is_white else Data.Damage_Types.BLACK)
	if is_dead: _die()


func _die() -> void:
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
