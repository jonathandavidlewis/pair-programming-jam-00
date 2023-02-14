extends Node

func _ready():
	Signals.connect("level_completed", self, "_on_level_completed")
	Signals.connect("level_failed", self, "_on_level_failed")
	pass # Replace with function body.

	
func _on_level_completed(level_slug) -> void:
	print("Going to load a new level now...")
	load_level(level_slug)
	pass
		
func _on_level_failed() -> void:
	restart_level()

func load_level(name) -> void:
	get_tree().change_scene("src/" + name)

func restart_level() -> void:
	get_tree().reload_current_scene()
