extends Node

func _ready():
	Signals.connect("level_completed", self, "_on_level_completed")
	pass # Replace with function body.

func _on_level_completed(level_slug):
	print("Going to load a new level now...")
	load_level(level_slug)
	pass

func load_level(name) -> void:
	get_tree().change_scene(name)
