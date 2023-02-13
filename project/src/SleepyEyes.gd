extends Node2D

onready var animation_player = get_node("EyeLids/AnimationPlayer")

func _ready() -> void:
	Signals.connect("button_pressed", self, "_on_button_pressed")

func _on_button_pressed(button_name) -> void:
	if button_name == "start":
		animation_player.play("SleepyEyeMovement")

func _on_AnimationPlayer_animation_finished(_anim_name):
	Signals.emit_signal("level_completed", "TitleCard.tscn")
