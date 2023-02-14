extends Node2D

export var DICE_WAIT_TIME_SECONDS = 5
onready var DIALOG_MANAGER = get_node("DialogManager")
onready var LEVEL_MANAGER = get_node("/root/LevelManager")
onready var PLAYER = $PlayerChar
onready var DICE_NODE = $Die


func _ready() -> void:
	DICE_NODE.hide()
	Signals.connect("goal_completed", self, "_on_goal_completed")
	Signals.connect("dialog_finished", self, "_on_dialog_finished")
	DIALOG_MANAGER.open_dialogs(["OhYeah", "DeathHoles"], "dialog_finished")

func _on_dialog_finished():
	yield(get_tree().create_timer(DICE_WAIT_TIME_SECONDS), "timeout")
	DIALOG_MANAGER.open_dialog("SorryDice")
	DICE_NODE.show()
