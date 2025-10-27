class_name AttackArea extends Area2D


@export var attack_data:AttackData

var is_white:bool = false

@onready var collider: CollisionShape2D = %collider


func setup_attack(new_data:AttackData) -> void:
	attack_data = new_data
	collider.set_deferred(&"disabled", false)


func get_damage() -> Damage:
	collider.set_deferred(&"disabled", true)
	get_tree().create_timer(0.1, false).timeout.connect(_reset_collider)
	return attack_data.get_damage()


func is_white_damage() -> bool:
	return attack_data.damage.type == Damage.Types.WHITE


func _reset_collider() -> void:
	collider.set_deferred(&"disabled", false)
