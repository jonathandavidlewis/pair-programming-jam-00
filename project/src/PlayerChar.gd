extends KinematicBody2D

export(int) var MAX_VELOCITY := 100
export(float) var ACCELERATION := 3.0
export(float) var DASH_MULTIPLIER := 12.0
export(int) var DASH_ACCEL_MULT := 30
export(float) var DASH_WAIT := 1.0
export(float) var DASH_DURRATION := 0.3

var velocity := Vector2()
var can_move := true
var dash_timeout := false
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
	return !dash_timeout

func is_dashing() -> bool:
	return dashing

func dash(durration, target_velocity, acceleration, delta) -> void:
	set_dashing(true)
	set_velocity(target_velocity, acceleration, delta)
	disable_dash()
	set_dash_durration(durration, "set_dashing", [false])

func set_dashing(state: bool) -> void:
	DEATH_HIT_BOX.disabled = state
	dashing = state

func set_velocity(target_velocity, acceleration, delta) -> void:
	velocity = velocity.linear_interpolate(target_velocity, acceleration * delta)

func disable_dash() -> void:
	dash_timeout = true
	set_dash_timeout(DASH_WAIT)

func set_dash_durration(time: float, call_back: String, call_back_arg: Array) -> void:
	var durration_timer = Timer.new()
	durration_timer.wait_time = time
	durration_timer.connect("timeout", self, call_back, call_back_arg)
	durration_timer.one_shot = true
	add_child(durration_timer)
	durration_timer.start()

func set_dash_timeout(time: float) -> void:
	var dash_timer = Timer.new()
	dash_timer.wait_time = time
	dash_timer.connect("timeout", self, "enable_dashing")
	dash_timer.one_shot = true
	add_child(dash_timer)
	dash_timer.start()

func enable_dashing() -> void:
	dash_timeout = false

func die() -> void:
	DEATH_SOUND.play()
	self.can_move = false
	self.visible = false
	yield(get_tree().create_timer(0.62), "timeout")
	Signals.emit_signal("level_failed")
