extends AudioStreamPlayer

onready var tween_out = get_node("Tween")

export var transition_duration = 6.00
export var transition_type = 1

func fade_out():
	tween_out.interpolate_property(self, "volume_db", self.volume_db, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()

func _on_TweenOut_tween_completed(object, key):
	object.stop()
