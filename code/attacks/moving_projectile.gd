class_name MovingProjectile extends AttackArea


@onready var sprite: Sprite2D = %sprite

var move_active := false
var _timer := 0.0


func _process(delta: float) -> void:
	if move_active:
		global_position += transform.x * attack_data.move_speed * delta
		_timer += delta
		if _timer >= attack_data.life_time: _destroy()


func setup_attack(new_data:AttackData) -> void:
	attack_data = new_data
	sprite.modulate = Data.BLACK if attack_data.damage.type == Data.Damage_Types.BLACK else Data.WHITE


func shoot(new_position:Vector2, new_rotation:float) -> void:
	global_position = new_position
	rotation = new_rotation
	move_active = true


func get_damage() -> Damage:
	_destroy.call_deferred()
	return attack_data.get_damage()


func _destroy() -> void:
	queue_free.call_deferred()
