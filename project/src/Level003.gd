extends Node2D

onready var DIALOG_MANAGER = get_node("DialogManager")

func _ready() -> void:
	DIALOG_MANAGER.open_dialogs(["DToMove", "SpaceToClose", "Sorry"])
