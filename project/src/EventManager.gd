extends Node


func _ready() -> void:
	Signals.connect("goal_complete", self, "_on_goal_complete")


func _on_goal_complete(goal_slug) -> void:
	print(goal_slug)
