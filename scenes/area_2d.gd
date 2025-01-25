extends Area2D

@export var damage_amount = 25

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered1(player):
	if player.is_in_group("player"):
		if player.has_method("take_damage"):
			player.take_damage(damage_amount)
			
func _on_body_entered(player):
	if player.is_in_group("player"):
		if player.has_method("take_damage"):
			player.take_damage(damage_amount)
		else:
			print("Player does not have take_damage method")
	else:
		print("Player is not in 'player' group")
