class_name Controls extends RidControl


@onready var return_button: Button = %return_button


func _ready() -> void:
	return_button.pressed.connect(_return_button_pressed)


func toggle_rid_control(_id := &"", display := false) -> void:
	if _id == id:
		if display:
			return_button.grab_focus()
			show()
		else:
			hide()


func _return_button_pressed() -> void:
	Signals.toggle_screen.emit(id, false)
	Signals.toggle_screen.emit(&"main_menu", true)
