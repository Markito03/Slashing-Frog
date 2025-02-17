extends Node
@onready var background = $TextureRect2

func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level1.tscn")


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level2.tscn")


func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level3.tscn")
	

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
