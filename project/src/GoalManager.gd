extends Node

export(String) var next_level = "Level000.tscn"
var goals := {}

onready var LEVEL_COMPLETE_SOUND = $LevelCompleteSound
onready var goal_nodes = $Goals.get_children()

func _ready() -> void:
	goals = create_checklist_from_goal_nodes(goal_nodes)
	Signals.connect("goal_completed", self, "_on_goal_completed")

func _on_goal_completed(goal_slug) -> void:
	goals[goal_slug] = true
	if all_goals_complete():
		LEVEL_COMPLETE_SOUND.play()
		var sound_duration = LEVEL_COMPLETE_SOUND.stream.get_length()
		yield(get_tree().create_timer(sound_duration), "timeout")
		Signals.emit_signal("all_goals_completed")
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
