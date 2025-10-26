class_name AttackData extends Resource


@export var damage:Damage


func get_damage() -> Damage:
	return damage.duplicate(true)


func set_new_owner(new_owner:CharacterData) -> void:
	damage.damage_owner = new_owner
