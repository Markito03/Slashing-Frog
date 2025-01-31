extends Node

#@export var damage_amount = 25
@export var main_menu_scene: String = "res://main_menu.tscn"

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
func _on_body_entered(body):
	# Überprüfen, ob der berührende Körper der Spieler ist
	if body.is_in_group("player"):  # Optional: Falls du den Spieler in einer Gruppe hast
		print("Spieler hat die Kollision berührt!")
		_go_to_main_menu()

func _go_to_main_menu():
	if main_menu_scene == "":
		print("Fehler: Kein Szenenpfad angegeben!")
		return

	print("Lade Hauptmenü-Szene von Pfad: ", main_menu_scene)
	var packed_scene = ResourceLoader.load(main_menu_scene)
	
	if packed_scene == null:
		print("Fehler: Die Szene konnte nicht geladen werden. Überprüfe den Pfad!")
		return
	
	print("Wechsle zur Hauptmenü-Szene...")
	get_tree().change_scene_to_packed(packed_scene)
	print("Szenenwechsel abgeschlossen!")
