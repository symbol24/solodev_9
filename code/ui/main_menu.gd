class_name MainMenu extends RidControl


@onready var btn_play: Button = %btn_play
@onready var btn_controls: Button = %btn_controls
@onready var btn_credits: Button = %btn_credits


func _ready() -> void:
	btn_play.pressed.connect(_play_btn_pressed)
	btn_controls.pressed.connect(_controls_btn_pressed)
	btn_credits.pressed.connect(_credits_btn_pressed)


func toggle_rid_control(_id := &"", display := false) -> void:
	if _id == id:
		if display:
			btn_play.grab_focus()
			show()
		else:
			hide()


func _play_btn_pressed() -> void:
	Signals.toggle_screen.emit(id, false)
	Signals.load_scene.emit(&"test_level", true, true)


func _controls_btn_pressed() -> void:
	Signals.toggle_screen.emit(id, false)
	Signals.toggle_screen.emit(&"controls", true)


func _credits_btn_pressed() -> void:
	Signals.toggle_screen.emit(id, false)
	Signals.toggle_screen.emit(&"credits", true)
