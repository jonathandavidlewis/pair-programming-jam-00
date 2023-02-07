extends Area2D

onready var COLLIDER := get_node("CollisionShape2D")

func _on_HoleCollider_body_entered(body: Node) -> void:
	if body.is_in_group("Die"):
		call_deferred("disable_collider")

func disable_collider() -> void:
	COLLIDER.disabled = true
