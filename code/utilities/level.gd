class_name Level extends Node2D


@export var enemy_waves:Dictionary = {0:
										{
											&"wave_count" : 1,
											&"data" : null,
											&"spawn_per_wave" : 1,
											&"interval" : 1.0
										}
									}
@export var round_count := 1

var _spawn_point:Marker2D = null:
	get:
		if _spawn_point == null: _spawn_point = get_tree().get_first_node_in_group(&"spawn_point")
		return _spawn_point

@onready var square: Sprite2D = %Square
@onready var square_2: Sprite2D = %Square2
@onready var square_3: Sprite2D = %Square3
@onready var square_4: Sprite2D = %Square4


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	add_to_group(&"level")
	Signals.toggle_ground_color.connect(_toggle_square_colors)
	Signals.toggle_ground_color.emit(Data.BLACK)
	Signals.toggle_screen.emit(&"play_ui", true)
	Signals.spawn_character.emit(Data.player_character_data, _spawn_point.global_position)


func _toggle_square_colors(color:Color) -> void:
	if color == Data.WHITE:
		square.modulate = Data.BLACK
		square_2.modulate = Data.BLACK
		square_3.modulate = Data.BLACK
		square_4.modulate = Data.BLACK
	else:
		square.modulate = Data.WHITE
		square_2.modulate = Data.WHITE
		square_3.modulate = Data.WHITE
		square_4.modulate = Data.WHITE
		
