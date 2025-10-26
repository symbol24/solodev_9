class_name Level extends Node2D


@export var enemy_waves:Dictionary = {0:
										{
											&"wave_count" : 1,
											&"data" : null,
											&"spawn_per_wave" : 1,
											&"interval" : 1.0
										}
									}


var _spawn_point:Marker2D = null:
	get:
		if _spawn_point == null: _spawn_point = get_tree().get_first_node_in_group(&"spawn_point")
		return _spawn_point


func _ready() -> void:
	add_to_group(&"level")
	Signals.toggle_ground_color.emit(Data.BLACK)
	Signals.toggle_screen.emit(&"play_ui", true)
	Signals.spawn_character.emit(Data.player_character_data, _spawn_point.global_position)
