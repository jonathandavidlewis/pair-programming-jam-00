extends Node2D

onready var DIALOG_MANAGER = get_node("DialogManager")
onready var LEVEL_MANAGER = get_node("/root/LevelManager")
onready var PLAYER = $PlayerChar
onready var DEATH_SOUND = PLAYER.get_node("Sound/DeathSound")

func _ready() -> void:
	Signals.connect("goal_completed", self, "_on_goal_completed")
	DIALOG_MANAGER.open_dialog("RememberHowMove")

func _on_goal_completed(goal_name) -> void:
	if goal_name == "Oops":
		simulate_player_death()

func simulate_player_death():
	PLAYER.can_move = false
	DIALOG_MANAGER.get_node("GameOver").show()
	DEATH_SOUND.play()
	yield(get_tree().create_timer(2.0), "timeout")
	LEVEL_MANAGER.load_level("Level005.tscn")
