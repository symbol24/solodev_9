class_name MainMenu extends RidControl


@onready var btn_play: Button = %btn_play


func _ready() -> void:
	btn_play.pressed.connect(_play_btn_pressed)


func _play_btn_pressed() -> void:
	print("sending load scene signal")
	Signals.load_scene.emit(&"test_level", true, true)
	hide()