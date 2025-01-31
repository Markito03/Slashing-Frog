extends CharacterBody2D

const MAX_HEALTH = 100
var health = MAX_HEALTH
const SPEED = 300.0
const JUMP_VELOCITY = -800.0
@onready var animated_sprite2d = $AnimatedSprite2D

var  jump_count = 0
const MAX_JUMPS = 2

func _physics_process(delta: float) -> void:
	if (velocity.x > 1 || velocity.x < -1):
		animated_sprite2d.animation = "run"
	else:
		animated_sprite2d.play("default")
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_floor():
		jump_count = 0
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and jump_count < MAX_JUMPS:
		velocity.y = JUMP_VELOCITY
		jump_count += 1


		
	if (velocity.y < 0 ): 
		animated_sprite2d.play("jump")
		
	if (velocity.y > 0):
		animated_sprite2d.play("fall")
	

	#print(animated_sprite2d.animation)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	animated_sprite2d.flip_h = velocity.x < 0
	#Damage kriegen Function / sterben#
func take_damage(amount):
	health -= amount
	if health <= 0:
		get_tree().change_scene_to_file("res://Main Menue/main_menu.tscn")
