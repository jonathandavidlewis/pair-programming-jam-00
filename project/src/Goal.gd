extends Area2D

func _ready() -> void:
	pass


func _on_Goal_body_entered(body:Node) -> void:
	Signals.emit_signal("goal_complete", self.name)
	print ("goal body entered")