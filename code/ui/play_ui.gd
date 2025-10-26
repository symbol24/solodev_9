class_name PlayUi extends RidControl


@onready var timer: Label = %timer
@onready var start_timer: Label = %start_timer



func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	Signals.toggle_ground_color.connect(_swap_color)
	Signals.timer_updated.connect(_update_timer)
	Signals.start_countdown.connect(_start_countdown)


func _swap_color(color:Color) -> void:
	if color == Data.WHITE:
		timer.modulate = Data.BLACK
	else:
		timer.modulate = Data.WHITE


func _update_timer(value:String) -> void:
	timer.text = value


func _start_countdown() -> void:
	await get_tree().create_timer(0.4).timeout
	start_timer.show()
	var c := 3
	for x in c:
		if x < c:
			start_timer.text = str(c - x)
		await get_tree().create_timer(1.0).timeout
	start_timer.text = "GO!"
	Signals.start_run.emit()
	await get_tree().create_timer(1.0).timeout
	start_timer.hide()
