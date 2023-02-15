extends Node2D

onready var DIALOG_MANAGER = get_node("DialogManager")
onready var LEVEL_MANAGER = get_node("/root/LevelManager")
onready var PLAYER = $PlayerChar


func _ready() -> void:
	Signals.connect("goal_completed", self, "_on_goal_completed")
	Signals.connect("dialog_finished", self, "_on_dialog_finished")
	DIALOG_MANAGER.open_dialogs(["Wierd", "CodingIsHard"], "dialog_finished")

func _on_goal_completed(goal_slug) -> void:
	if goal_slug == "DontLeave":
		DIALOG_MANAGER.open_dialogs(["WantToLeave", "DontLeave"])
	if goal_slug == "NoCherries":
		DIALOG_MANAGER.open_dialogs(["NotCherries"])
