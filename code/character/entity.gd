class_name Entity extends CharacterBody2D


var _data:CharacterData
var is_white:bool:
	get:
		return sprite.modulate == Data.WHITE
var _level:Level = null:
	get:
		if _level == null: _level = get_tree().get_first_node_in_group(&"level")
		return _level
var _is_active := false

@onready var sprite: Sprite2D = %sprite


func hurt(damage:Damage) -> void:
	print(name, " received: ", damage.value)
