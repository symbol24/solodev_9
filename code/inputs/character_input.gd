class_name CharacterInput extends InputProcess


var character:Character = null:
	get:
		if character == null: character = get_parent()
		return character


func process_input(_delta:float, _event:InputEvent) -> void:
	character.set_direction(Input.get_vector("left", "right", "up", "down"))
	if Data.active_data.input_type == InputManager.Type.XBOX:
		character.move_aim(Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down"))
	elif Data.active_data.input_type == InputManager.Type.MOUSEANDKEYBOARD:
		character.look_at_mouse(get_global_mouse_position())
	if _event != null:
		if _event.is_action_pressed("attack"): character.trigger_attack(true)
		elif _event.is_action_released("attack"): character.trigger_attack(false)
		if _event.is_action_pressed("switch"): character.trigger_switch()
		if _event.is_action_pressed("pause"): character.trigger_pause()
