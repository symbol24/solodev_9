class_name Character extends Entity


var _input:CharacterInput = null
var _direction := Vector2.ZERO
var _aim_direction := Vector2.RIGHT
var _shooting := false
var _shoot_timer := 0.0
var _delay := 0.7

@onready var remote_transform: RemoteTransform2D = %remote_transform
@onready var shoot_point_1: Marker2D = %shoot_point_1
@onready var shoot_point_2: Marker2D = %shoot_point_2


func _ready() -> void:
	add_to_group(&"player")
	Signals.start_level.connect(_start_level)
	Signals.character_spawned.emit(self)


func _process(delta: float) -> void:
	if _is_active:
		if Data.active_data.input_type == InputManager.Type.XBOX and _aim_direction.length() > 0.3:
			rotation = _aim_direction.angle()
		velocity = _move(_direction, velocity, delta)
		velocity.limit_length(1.0)
		move_and_slide()
		
		if _shooting: 
			_shoot_timer += delta
			if _shoot_timer >= _delay:
				_shoot_timer = 0.0
				_shoot_once()
		else: 
			if _shoot_timer != 0.0:
				_shoot_timer += delta
				if _shoot_timer >= _delay:
					_shoot_timer = 0.0


func _exit_tree() -> void:
	_input.unregister()


func setup_character(new_data:PlayerCharacterData) -> void:
	_data = new_data.duplicate(true)
	_data.setup_character()
	_input = CharacterInput.new()
	add_child(_input)
	_input.register()
	sprite.modulate = Data.WHITE


func set_direction(value:Vector2) -> void:
	if _is_active:
		_direction = value


func move_aim(value:Vector2) -> void:
	if _is_active:
		_aim_direction = value


func look_at_mouse(value:Vector2) -> void:
	if _is_active:
		look_at(value)


func trigger_attack(value:bool) -> void:
	_shooting = value
	if _is_active:
		if _shooting and _shoot_timer == 0.0: _shoot_once()


func trigger_switch() -> void:
	if _is_active:
		if is_white:
			sprite.modulate = Data.BLACK
			Signals.toggle_ground_color.emit(Data.WHITE)
		else:
			sprite.modulate = Data.WHITE
			Signals.toggle_ground_color.emit(Data.BLACK)


func trigger_pause() -> void:
	pass


func get_imune_time() -> float:
	return _data.imune_time


func _move(direction:Vector2, current:Vector2, delta:float) -> Vector2:
	if direction == Vector2.ZERO:
		return current.move_toward(Vector2.ZERO, delta * CharacterData.FRICTION)
	else:
		#return current.move_toward(current + (direction * _data.speed), delta * CharacterData.ACCELERATION)
		var x:float = move_toward(current.x, direction.x * _data.speed, delta * CharacterData.ACCELERATION)
		var y:float = move_toward(current.y, direction.y * _data.speed, delta * CharacterData.ACCELERATION)
		return Vector2(x, y)


func _start_level() -> void:
	_is_active = true


func _shoot_once() -> void:
	if _is_active:
		var to_shoot:MovingProjectileData = _data.white_attack if is_white else _data.black_attack
		var to_insta:PackedScene = load(to_shoot.path)
		var one:MovingProjectile = to_insta.instantiate()
		var two:MovingProjectile = to_insta.instantiate()
		_level.add_child(one)
		_level.add_child(two)
		one.setup_attack(to_shoot)
		two.setup_attack(to_shoot)
		one.attack_data.set_new_owner(_data)
		two.attack_data.set_new_owner(_data)
		one.shoot(shoot_point_1.global_position, rotation)
		two.shoot(shoot_point_2.global_position, rotation)
