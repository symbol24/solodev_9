class_name PauseMenu extends RidControl


@onready var continue_button: Button = %continue_button
@onready var return_button: Button = %return_button


func _ready() -> void:
	continue_button.pressed.connect(_continue_button_pressed)
	return_button.pressed.connect(_return_button_pressed)


func toggle_rid_control(_id := &"", display := false) -> void:
	if _id == id:
		if display:
			continue_button.grab_focus()
			show()
		else:
			hide()


func _continue_button_pressed() -> void:
	Signals.toggle_screen.emit(id, false)
	Signals.toggle_pause.emit(false)
	Signals.refocus_input.emit()


func _return_button_pressed() -> void:
	Signals.unload_level.emit()
	Signals.toggle_screen.emit(&"main_menu", true)
	Signals.toggle_screen.emit(id, false)
	
