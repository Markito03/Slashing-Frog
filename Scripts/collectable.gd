extends Area2D

@onready var game_manager = %GameManager
@onready var cherries = $AnimatedSprite2D
@onready var my_timer = $Timer

	


func _on_body_entered(body):
	
	if (body.is_in_group("player")):
		cherries.play("collected")
		game_manager.add_point()
		my_timer.timeout.connect(_on_timer_timeout)
		my_timer.wait_time = 0.4
		my_timer.start()
		
		


func _on_timer_timeout() -> void:
	queue_free()
