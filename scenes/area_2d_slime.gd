extends Area2D

var speed = 100
var player

func _ready():
	player = get_node("res://scenes/main_character.tscn") # Pfad zum Spieler anpassen


		
func _process(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		$AnimatedSprite2D.play("default")
		$AnimatedSprite2D.flip_h = direction.x < 0
		
var detection_range = 200

func _physics_process(delta):
	if player:
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player < detection_range:
			var direction = (player.global_position - global_position).normalized()
			move_and_collide(direction * speed * delta) # Für RigidBody2D
			# Oder: move_and_slide(direction * speed) # Für KinematicBody2D
			$AnimatedSprite2D.play("default")
			$AnimatedSprite2D.flip_h = direction.x < 0
		else:
			$AnimatedSprite2D.play("default") # oder "idle", je nachdem, wie Ihre Animation heißt
	else:
		# Verhalten, wenn kein Spieler gefunden wurde
		$AnimatedSprite2D.play("default")
func _ready_check():
	print("Player: ", player)
	print("Speed ", speed)
	print("Detectionc range: ", detection_range)
