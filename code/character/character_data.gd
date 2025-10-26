class_name CharacterData extends Resource


const ACCELERATION := 700.0
const FRICTION := 1000.0


@export var id := &""
@export var path := ""

@export_category("Stats")
@export var starting_hp := 10
@export var starting_lives := 1
@export var starting_movement_speed := 100.0
@export var starting_imune_time := 0.4


var current_hp := 10
var max_hp := 10
var current_lives := 1
var speed := 100.0
var imune_time := 0.1


func setup_character() -> void:
	max_hp = starting_hp
	current_hp = max_hp
	current_lives = starting_lives
	speed = starting_movement_speed
	imune_time = starting_imune_time


func apply_damage(damage:Damage, parent_type:Data.Damage_Types) -> bool:
	if damage.type == parent_type:
		current_hp -= damage.value
		if current_hp <= 0:
			current_lives -= 1
			if current_lives > 0:
				current_hp = max_hp
			else:
				return true

	return false
