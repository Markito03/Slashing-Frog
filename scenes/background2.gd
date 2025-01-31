extends Node2D

@onready var background = $TextureRect

var start_x 
var start_y

func _ready() -> void:
	start_x = background.position.x
	start_y = background.position.y
func move_tiles():
	background.position.x -= 1
	background.position.y -= 1
	
	if background.position.x == start_x - 64:
		background.position.x = start_x
		background.position.y = start_y

func _process(delta: float) -> void:
	move_tiles()
