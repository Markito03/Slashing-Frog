extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
const SPEED = 150.0

var direction = 1
var health = 1

func add_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		

func move_enemy():
	velocity.x = SPEED * direction
	animated_sprite.play("run")
func platform_edge():
	if not $RayCast2D.is_colliding():
		direction = -direction
		$RayCast2D.position.x * -1
	
func reverse_direction():
	if is_on_wall():
		direction = -direction
		animated_sprite.flip_h = !animated_sprite.flip_h
	
	
	
	

func _physics_process(delta: float) -> void:
	add_gravity(delta)
	move_enemy()
	move_and_slide()
	platform_edge()
	reverse_direction()
		
