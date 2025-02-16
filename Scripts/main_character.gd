extends CharacterBody2D

const MAX_HEALTH = 100
var health = MAX_HEALTH
const SPEED = 300.0
const JUMP_VELOCITY = -800.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var dash_duration_timer: Timer = $DashDurationTimer
@onready var dash_effect_timer: Timer = $DashEffectTimer
@onready var dash_cool_down_timer: Timer = $DashCoolDownTimer

var  jump_count = 0
var direction = 0
var is_wall_sliding = false
var friction = 50
var can_wall_slide = true
var is_dashing = false
var can_dash = true
var dash_speed = 3

func dash_effect():
	var animated_sprite_2d = $AnimatedSprite2D.duplicate()
	var animation_time = dash_duration_timer.wait_time / dash_speed
	var fade_steps = 3
	var fade_amount = 0.4
	
	get_parent().add_child((animated_sprite_2d))
	animated_sprite_2d.global_position = global_position
	
	for i in range(fade_steps):
		await get_tree().create_timer((animation_time)).timeout
		animated_sprite_2d.modulate.a -= fade_amount
		 
	animated_sprite_2d.queue_free()
	
		

func dash():
	if (Input.is_action_just_pressed("dash") and can_dash):
		is_dashing = true
		can_dash = false
		dash_cool_down_timer.start()
		dash_duration_timer.start()
		dash_effect_timer.start()
		
	if is_dashing:
		velocity.x = direction * SPEED * dash_speed
		velocity.y = 0
		
func animate():
	if (velocity.x == 0 and velocity.y == 0):
		animated_sprite.play("default")
	if (velocity.y < 0 and jump_count < 1):
		animated_sprite.play("jump")
	if (velocity.y > 0):
		animated_sprite.play("fall")
	if ((velocity.x < 0 or velocity.x > 0) and (velocity.y == 0)):
		animated_sprite.play("run")
	if (velocity.y < 0 and jump_count > 0):
		animated_sprite.play("double_jump")
	if (is_wall_sliding):
		animated_sprite.play("wall_jump")

func double_jump():
	if (not is_on_floor() and jump_count < 1 and  Input.is_action_just_pressed("jump")):
		velocity.y = JUMP_VELOCITY
		jump_count += 1
	if (is_on_floor()):
		jump_count = 0

func get_direction():
	direction = Input.get_axis("left", "right")
	if direction > 0:
		animated_sprite.flip_h = false
	if direction < 0:
		animated_sprite.flip_h = true 
	
func _physics_process(delta: float) -> void:
	
	add_gravity(delta)
	get_direction()
	animate()
	jump()
	double_jump()
	wall_slide()
	run()
	jump_thru()
	dash()
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
		await get_tree().create_timer(5.0).timeout
		can_wall_slide = true
	else:
		is_wall_sliding = false
	
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
		

func take_damage(amount):
	health -= amount
	if health <= 0:
		get_tree().change_scene_to_file("res://Main Menue/main_menu.tscn")

func _on_dash_duration_timer_timeout() -> void:
	is_dashing = false
	dash_effect_timer.stop()

func _on_dash_cool_down_timer_timeout() -> void:
	can_dash = true



func _on_dash_effect_timer_timeout() -> void:
	dash_effect()
