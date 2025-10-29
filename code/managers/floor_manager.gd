class_name FloorManager extends Node2D


const FINAL_SIZE := Vector2(330, 190)
const ANIM_TIME := 0.4


@export var white_panel:Sprite2D
@export var black_panel:Sprite2D

var animating := false
var timer:float = 0.0
var to_show := white_panel
var to_hide := black_panel


func _ready() -> void:
	Signals.toggle_ground_color.connect(_animate_switch)
	Signals.character_spawned.connect(_attach_to_character)
	global_position = get_tree().get_first_node_in_group(&"spawn_point").global_position
	await get_tree().create_timer(0.1).timeout
	white_panel.scale = FINAL_SIZE
	white_panel.modulate = Data.WHITE
	white_panel.hide()
	black_panel.scale = FINAL_SIZE
	black_panel.modulate = Data.BLACK


func _process(delta: float) -> void:
	if animating:
		timer += delta
		_scale(delta)
		if timer >= ANIM_TIME: _end_animation()


func _scale(delta:float) -> void:
	var x:float = move_toward(to_show.scale.x, FINAL_SIZE.x, delta * (FINAL_SIZE.x / ANIM_TIME))
	var y:float = move_toward(to_show.scale.y, FINAL_SIZE.y, delta * (FINAL_SIZE.y / ANIM_TIME))
	to_show.scale = Vector2(x, y)


func _animate_switch(color:Color) -> void:
	if animating:
		_end_animation()
		to_show.scale = FINAL_SIZE
		
	if not animating:
		if color == Data.BLACK:
			to_show = black_panel
			to_hide = white_panel
		else:
			to_show = white_panel
			to_hide = black_panel
		
		move_child(to_show, 1)
		to_show.show()
		animating = true


func _end_animation() -> void:
	to_hide.scale = Vector2.ONE
	to_hide.hide()
	animating = false
	timer = 0.0
	Signals.floor_animation_complete.emit()


func _attach_to_character(character:Character) -> void:
	character.remote_transform.remote_path = get_path()
