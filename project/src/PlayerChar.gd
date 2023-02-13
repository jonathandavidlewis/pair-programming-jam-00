extends KinematicBody2D

export(int) var MAX_VELOCITY := 100
export(float) var ACCELERATION := 3.0
export(float) var DASH_MULTIPLIER := 12.0
export(int) var DASH_ACCEL_MULT := 30
export(float) var DASH_WAIT := 1.0
export(float) var DASH_DURRATION := 0.3
export(float) var DASH_USE_DURRATION := 10.0

var velocity := Vector2()
var can_move := true
var dash_ability_timeout := true
var dash_timeout := true
var dashing := false

onready var DEATH_HIT_BOX = $Area2D/CollisionPolygon2D
onready var DEATH_SOUND = $Sound/DeathSound

func _physics_process(delta: float) -> void:
	var target_velocity = get_input_direction() * MAX_VELOCITY

	if !can_move:
		return
	
	if get_input_abilities() == "dash" and can_dash():
		DEATH_HIT_BOX.disabled = true
		dash(DASH_DURRATION, target_velocity * DASH_MULTIPLIER, ACCELERATION * DASH_ACCEL_MULT, delta)

	if !is_dashing():
		DEATH_HIT_BOX.disabled = false
		set_velocity(target_velocity, ACCELERATION, delta)

	velocity = move_and_slide(velocity)

func _on_Area2D_area_entered(area:Area2D) -> void:
	if area.is_in_group("Death"):
		die()
	
	if area.is_in_group("Pickup") and area.name == "DashPickup":
		enable_dash_ability()
		enable_dash()
		set_dash_use_durration(DASH_USE_DURRATION, "disable_dash_ability", [])
		print("dash enabled")

func get_input_abilities() -> String:
	if Input.is_action_just_pressed("ui_accept"):
		return "dash"
	return "none"

func get_input_direction() -> Vector2:
	var input_direction = Vector2(0, 0)
	
	if Input.is_action_pressed("ui_left"):
		input_direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_direction.x += 1
	if Input.is_action_pressed("ui_up"):
		input_direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		input_direction.y += 1
	
	return input_direction.normalized()

func can_dash() -> bool:
	return !is_dash_ability_timeout() and !is_dash_timeout()

func is_dash_ability_timeout() -> bool:
	return dash_ability_timeout

func is_dash_timeout() -> bool:
	return dash_timeout

func is_dashing() -> bool:
	return dashing

func dash(durration, target_velocity, acceleration, delta) -> void:
	set_dashing(true)
	set_velocity(target_velocity, acceleration, delta)
	disable_dash()
	set_dash_timeout(DASH_WAIT)
	set_dash_durration(durration, "set_dashing", [false])

func set_dashing(state: bool) -> void:
	DEATH_HIT_BOX.disabled = state
	dashing = state

func set_velocity(target_velocity, acceleration, delta) -> void:
	velocity = velocity.linear_interpolate(target_velocity, acceleration * delta)

func disable_dash() -> void:
	dash_timeout = true

func set_dash_use_durration(time: float, call_back: String, call_back_arg: Array) -> void:
	var can_dash_timer = create_timer(time, call_back, call_back_arg)
	add_child(can_dash_timer)
	can_dash_timer.start()

func set_dash_durration(time: float, call_back: String, call_back_arg: Array) -> void:
	var durration_timer = create_timer(time, call_back, call_back_arg)
	add_child(durration_timer)
	durration_timer.start()

func set_dash_timeout(time: float) -> void:
	var dash_timer = create_timer(time, "enable_dash", [])
	add_child(dash_timer)
	dash_timer.start()

func enable_dash() -> void:
	dash_timeout = false

func enable_dash_ability() -> void:
	dash_ability_timeout = false

func disable_dash_ability() -> void:
	dash_ability_timeout = true

func create_timer(time: float, callback_name: String, callback_arg: Array) -> Timer:
	var timer_signal = "timeout"
	var timer = Timer.new()
	timer.wait_time = time
	timer.connect(timer_signal, self, callback_name, callback_arg)
	timer.one_shot = true
	return timer

func die() -> void:
	DEATH_SOUND.play()
	self.can_move = false
	self.visible = false
	Signals.emit_signal("player_died")
	yield(get_tree().create_timer(0.62), "timeout")
	Signals.emit_signal("level_failed")
