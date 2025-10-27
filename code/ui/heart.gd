class_name Heart extends Control


var _is_active := true

@onready var inside: TextureRect = %inside
@onready var outline: TextureRect = %outline


func _ready() -> void:
	Signals.toggle_ground_color.connect(_toggle_color)
	_toggle_color(Data.BLACK)


func toggle_heart(value:bool) -> void:
	_is_active = value
	if value:
		inside.show()
	else:
		inside.hide()


func _toggle_color(player_color:Color) -> void:
	if player_color == Data.WHITE:
		inside.modulate = Data.BLACK
		outline.modulate = Data.BLACK
	else:
		inside.modulate = Data.WHITE
		outline.modulate = Data.WHITE
