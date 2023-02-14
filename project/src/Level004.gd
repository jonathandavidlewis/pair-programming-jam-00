extends Node2D

onready var DIALOG_MANAGER = get_node("DialogManager")
onready var LEVEL_MANAGER = get_node("/root/LevelManager")

func _ready() -> void:
	Signals.connect("goal_completed", self, "_on_goal_completed")

	DIALOG_MANAGER.open_dialog("RememberHowMove")

func _on_goal_completed(goal_name) -> void:
	if goal_name == "Oops":
		DIALOG_MANAGER.get_node("GameOver").show()
		yield(get_tree().create_timer(2.0), "timeout")
		LEVEL_MANAGER.load_level("Level005.tscn")
