extends Node2D

func _on_AnimationPlayer_animation_finished(_anim_name:String) -> void:
	Signals.emit_signal("level_completed", "Level000.tscn")
