extends TileMap

@export var damage_amount = 10


func _on_body_entered(player):
	if player.is_in_group("player"):
		if player.has_method("take_damage"):
			player.take_damage(damage_amount)
