extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("level_completed", self, "_on_level_completed")
	pass # Replace with function body.

func _on_level_completed():
	print("Going to load a new level now...")
	get_tree().reload_current_scene()
	# load level
	pass

func load_level(name):
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
