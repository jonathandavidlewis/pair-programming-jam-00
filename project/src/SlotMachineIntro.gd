extends Node2D

onready var slot_sound = $SlotSound

func _ready():
	Signals.connect("button_pressed", self, "_on_start_pressed")

func _on_start_pressed(_extra_arg) -> void:
	slot_sound.fade_out()
