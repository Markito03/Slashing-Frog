extends CharacterBody2D

const MAX_HEALTH = 100
var health = MAX_HEALTH
const SPEED = 300.0
const JUMP_VELOCITY = -800.0
@onready var animated_sprite2d = $AnimatedSprite2D

var  jump_count = 0
var direction = 0
var is_wall_sliding = false
var friction = 50
var can_wall_slide = true


func animate():
	if (velocity.x == 0 and velocity.y == 0):
		animated_sprite2d.play("default")
	if (velocity.y < 0 and jump_count < 1):
		animated_sprite2d.play("jump")
	if (velocity.y > 0):
		animated_sprite2d.play("fall")
	if ((velocity.x < 0 or velocity.x > 0) and (velocity.y == 0)):
		animated_sprite2d.play("run")
	if (velocity.y < 0 and jump_count > 0):
		animated_sprite2d.play("double_jump")
	if (is_wall_sliding):
		animated_sprite2d.play("wall_jump")
		
func double_jump():
	if (not is_on_floor() and jump_count < 1 and  Input.is_action_just_pressed("jump")):
		velocity.y = JUMP_VELOCITY
		jump_count += 1
	if (is_on_floor()):
		jump_count = 0

func get_direction():
	direction = Input.get_axis("left", "right")
	if direction > 0:
		animated_sprite2d.flip_h = false
	if direction < 0:
		animated_sprite2d.flip_h = true 
	
	
	
func _physics_process(delta: float) -> void:
	
	add_gravity(delta)
	get_direction()
	animate()
	jump()
	double_jump()
	wall_slide()
	run()
	jump_thru()
	move_and_slide()
	
func add_gravity(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_floor():
		jump_count = 0
func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
		
		jump_count += 1
func wall_slide():
	if (is_on_wall() and not is_on_floor() and Input.get_axis("left", "right")):
		is_wall_sliding = true
		velocity.y = friction
		jump_count = 0
		can_wall_slide = false
		await get_tree().create_timer(1.0).timeout
		can_wall_slide = true
	else:
		is_wall_sliding = false
	if Input.is_action_just_pressed("jump"):
		is_wall_sliding = false
		velocity.y = JUMP_VELOCITY
		
func run():
	#Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
func jump_thru():
	if (Input.is_action_pressed("Fall")):
		set_collision_mask_value(3, false)
	else:
		set_collision_mask_value(3, true)
	#Damage kriegen Function / sterben#
func take_damage(amount):
	health -= amount
	if health <= 0:
		get_tree().change_scene_to_file("res://Main Menue/main_menu.tscn")
