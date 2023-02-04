extends Node

var goals := {}

func _ready() -> void:
	var goal_nodes = self.get_children()
	goals = create_checklist_from_goal_nodes(goal_nodes)
	Signals.connect("goal_completed", self, "_on_goal_completed")

func _on_goal_completed(goal_slug) -> void:
	goals[goal_slug] = true
	if all_goals_complete():
		Signals.emit_signal("all_goals_completed")
		print("ALL GOALS COMPLETE")
	print(goal_slug)

func create_checklist_from_goal_nodes(goal_nodes) -> Dictionary:
	var checklist = {}
	for goal in goal_nodes:
		checklist[goal.name] = false
	return checklist

func all_goals_complete() -> bool:
	for goal in goals:
		if goals[goal] == false:
			return false
	return true
