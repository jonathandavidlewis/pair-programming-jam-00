extends Node2D

func _on_Area2D_body_entered(body:Node) -> void:
	if body.is_in_group("Player"):
		queue_free()
