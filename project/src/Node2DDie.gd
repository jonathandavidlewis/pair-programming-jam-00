extends RigidBody2D

export(float) var COEFFICIENT_OF_FRICTION = 1.0
onready var COLLIDER := get_node("CollisionShape2D")

func _integrate_forces(_state):
	var linear_velocity = get_linear_velocity()
	var velocity_decrease = -linear_velocity * COEFFICIENT_OF_FRICTION
	set_linear_velocity(linear_velocity + velocity_decrease)
	pass # Replace with function body.

func _on_Area2D_area_entered(area:Area2D) -> void:
	var self_pos = get_global_position()
	if area.is_in_group("Hole"):
		var hole_pos = area.get_global_position()
		var hole_rot = area.global_rotation
		var offset = Vector2(hole_pos.x - self_pos.x, hole_pos.y - self_pos.y)
		call_deferred("disable_colider")
		global_rotation_degrees = hole_rot
		global_translate(offset)
		z_index = -2

func disable_colider() -> void:
	COLLIDER.disabled = true

func hide() -> void:
	.hide()
	disable_colider()

func show() -> void:
	.show()
	COLLIDER.disabled = false
	
