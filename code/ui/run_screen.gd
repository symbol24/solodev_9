class_name RunScreen extends RidControl


var _success := "Congrats! You survived!"
var _failure := "Sorry, defeated!"

@onready var result: Label = %result
@onready var back_button: Button = %back_button


func _ready() -> void:
	Signals.run_result.connect(_result)
	back_button.pressed.connect(_back_button_pressed)


func toggle_rid_control(_id := &"", display := false) -> void:
	if _id == id:
		if display:
			Signals.request_run_result.emit()
			back_button.grab_focus()
			show()
		else:
			hide()


func _result(success:bool) -> void:
	if success: result.text = _success
	else: result.text = _failure


func _back_button_pressed() -> void:
	Signals.unload_level.emit()
	Signals.toggle_screen.emit(id, false)
	Signals.toggle_screen.emit(&"main_menu", true)
