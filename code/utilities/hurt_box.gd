class_name HurtBox extends Area2D


var _parent:Entity = null:
	get:
		if _parent == null: _parent = get_parent()
		return _parent

@onready var hurt_collider:CollisionShape2D = %hurt_collider


func _ready() -> void:
	area_entered.connect(_area_entered)


func _area_entered(area:Area2D) -> void:
	if area.has_method(&"get_damage"):
		#print("_parent.is_white: ",_parent.is_white, " area.is_white_damage(): ", area.is_white_damage())
		if (_parent.is_white and not area.is_white_damage()) or (not _parent.is_white and area.is_white_damage()):
			return
			
		_parent.hurt(area.get_damage())
		hurt_collider.set_deferred(&"disabled", true)
		get_tree().create_timer(_parent.get_imune_time(), false).timeout.connect(_reset_collider)


func _reset_collider() -> void:
	hurt_collider.set_deferred(&"disabled", false)
