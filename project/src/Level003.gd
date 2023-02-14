extends Node2D

onready var DIALOG_MANAGER = get_node("DialogManager")

func _ready() -> void:
	DIALOG_MANAGER.open_dialog("DToMove")
	yield(get_tree().create_timer(2.0), "timeout")
	DIALOG_MANAGER.open_dialog("SpaceToClose")
	yield(get_tree().create_timer(1.5), "timeout")
	DIALOG_MANAGER.open_dialog("Sorry")