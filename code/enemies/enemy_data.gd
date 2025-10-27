class_name EnemyData extends CharacterData


@export var texture:CompressedTexture2D
@export var oultine:CompressedTexture2D
@export var contact_damage:Damage
@export var projectile:MovingProjectileData


func get_color() -> Color:
	if contact_damage != null:
		return Data.WHITE if contact_damage.type == Damage.Types.WHITE else Data.BLACK
	if projectile != null:
		return Data.WHITE if projectile.damage.type == Damage.Types.WHITE else Data.BLACK
	return Color.DEEP_PINK
