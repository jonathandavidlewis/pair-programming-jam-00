extends Area2D

onready var COLLIDER := get_node("CollisionShape2D")

func disable_collider():
	COLLIDER.disabled = true

func _on_Goal_body_entered(body:Node) -> void:
	if body.is_in_group("Player"):
		call_deferred("disable_collider")
		Signals.emit_signal("goal_completed", self.name)
