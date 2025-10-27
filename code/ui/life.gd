class_name Life extends Control


@onready var fill: TextureRect = %fill


func _ready() -> void:
	Signals.toggle_ground_color.connect(_toggle_color)
	_toggle_color(Data.BLACK)


func _toggle_color(color:Color) -> void:
	if color == Data.WHITE:
		fill.modulate = Data.BLACK
	else:
		fill.modulate = Data.WHITE
