extends Node2D

func _on_AnimationPlayer_animation_finished(anim_name):
	Signals.emit_signal("level_completed", "Level000.tscn")
