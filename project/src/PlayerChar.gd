extends KinematicBody2D

export(int) var MAX_VELOCITY := 200
export(float) var ACCELERATION := 5.0
export(float) var DASH_MULTIPLIER := 3.5
export(int) var DASH_ACCEL_MULT := 10
export(float) var DASH_WAIT := 1.0

var dashing := false
var velocity := Vector2()
var can_move := true
var dash_timeout := false

onready var DEATH_SOUND = $Sound/DeathSound

func _physics_process(delta: float) -> void:
	
	if !can_move:
		return
	
	var target_velocity = get_input_direction() * MAX_VELOCITY
	set_velocity(target_velocity, ACCELERATION, delta)
	
	get_input_abilities(delta)
	
	velocity = move_and_slide(velocity)

func _on_Area2D_area_entered(area:Area2D) -> void:
	if area.is_in_group("Hole"):
		die()

func get_input_abilities(delta) -> void:
	if Input.is_action_just_pressed("ui_accept") and can_dash():
		set_dash_velocity(get_input_direction() * MAX_VELOCITY, ACCELERATION, delta)

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

	if dash_timeout == false:
		return true
	
	return false

func set_dash_velocity(target_velocity, acceleration, delta) -> void:
	set_dash_timer(true)
	set_velocity(target_velocity * DASH_MULTIPLIER, acceleration * DASH_ACCEL_MULT, delta)

func set_dash_timer(timer_state: bool) -> void:
	
	dash_timeout = timer_state

	if timer_state == false:
		print("you can't dash")
		return

	var dash_timer = Timer.new()
	dash_timer.connect("timeout", self, "set_dash_timer", [false])
	dash_timer.wait_time = DASH_WAIT
	dash_timer.one_shot = true
	add_child(dash_timer)
	dash_timer.start()
	print("dashing...")

func set_velocity(target_velocity, acceleration, delta) -> void:
	velocity = velocity.linear_interpolate(target_velocity, acceleration * delta)

func die() -> void:
	DEATH_SOUND.play()
	self.can_move = false
	self.visible = false
	yield(get_tree().create_timer(0.62), "timeout")
	Signals.emit_signal("level_failed")
