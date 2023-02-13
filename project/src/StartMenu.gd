extends Node

func _on_Start_pressed(extra_arg_0:String) -> void:
	Signals.emit_signal("button_pressed", extra_arg_0)
	get_node("Button").visible = false
