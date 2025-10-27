class_name RoundScreen extends RidControl


@onready var continue_button: Button = %continue_button
@onready var round_text: Label = %round_text


func _ready() -> void:
	Signals.round_count.connect(_update_round_text)


func toggle_rid_control(_id := &"", display := false) -> void:
	if _id == id:
		if display:
			Signals.request_round_count.emit()
			continue_button.grab_focus()
			show()
		else:
			hide()


func _update_round_text(round:int) -> void:
	round_text.text = "Round %s Completed!" % str(round)


func _continue_pressed() -> void:
	Signals.toggle_screen.emit(id, false)
	Signals.start_next_round.emit()
