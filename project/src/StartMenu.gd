extends Node

onready var start_button = $Button

func _ready():
	start_button.grab_focus()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_on_Start_pressed("start")

func _on_Start_pressed(extra_arg_0:String) -> void:
	Signals.emit_signal("button_pressed", extra_arg_0)
	get_node("Button").visible = false
