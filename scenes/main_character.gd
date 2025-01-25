extends CharacterBody2D

const MAX_HEALTH = 100
var health = MAX_HEALTH
const SPEED = 300.0
const JUMP_VELOCITY = -800.0
@onready var sprite_2d = $Sprite2D

var  jump_count = 0
const MAX_JUMPS = 2

func _physics_process(delta: float) -> void:
	if (velocity.x > 1 || velocity.x < -1):
		sprite_2d.animation = "running"
	else:
		sprite_2d.animation = "default"
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_floor():
		jump_count = 0
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and jump_count < MAX_JUMPS:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		
	if not is_on_floor():
		if velocity.y < 0 : 
			sprite_2d.animation = "jumping"
		else:
			sprite_2d.animation = "falling"

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	sprite_2d.flip_h = velocity.x < 0
	#Damage kriegen Function / sterben
func take_damage(amount):
	if is_on_floor() and abs(velocity.x) > 0.1:  # 10 ist ein Schwellenwert für die minimale Geschwindigkeit
		apply_spike_knockback()
	health -= amount
	if health <= 0:
		get_tree().change_scene_to_file("res://Main Menue/main_menu.tscn")

func apply_knockback(knockback_force: Vector2, duration: float):
	var tween = create_tween()
	tween.tween_property(self, "velocity", Vector2.ZERO, duration).from(knockback_force)

func apply_spike_knockback():
	var knockback_strength_horizontal = 10
	var knockback_strength_vertical = 400 # Negative Werte gehen nach oben
	var knockback_duration = 0.5

	var knockback_direction = Vector2(-sign(velocity.x), -1)  # Horizontale Richtung umkehren und nach oben
	var knockback_force = Vector2(
		knockback_direction.x * knockback_strength_horizontal,
		knockback_direction.y * knockback_strength_vertical
	)

	apply_knockback(knockback_force, knockback_duration)
