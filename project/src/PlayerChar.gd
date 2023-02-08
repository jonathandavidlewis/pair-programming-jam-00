extends KinematicBody2D

export(int) var MAX_VELOCITY := 10000 
export(int) var ACCELERATION := 5
export(float) var DASH_MULTIPLIER := 3.5
export(int) var DASH_ACCEL_MULT := 10
export(float) var DASH_WAIT := 1.0

var dashing := false
var velocity := Vector2()
var can_move := true

onready var DEATH_SOUND = $Sound/DeathSound


func _physics_process(delta: float) -> void:
	if !can_move:
		return
	var target_velocity = get_input_direction() * MAX_VELOCITY
	velocity = velocity.linear_interpolate(target_velocity, ACCELERATION * delta)
	var motion = velocity * delta
	motion = move_and_slide(motion)
	dash(target_velocity, delta)

func _on_Area2D_area_entered(area:Area2D) -> void:
	if area.is_in_group("Hole"):
		die()
		
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

func dash(target_velocity, delta):
	if Input.is_action_just_pressed("ui_accept") and !is_dashing():
		var motion
		set_dashing(true)
		velocity = velocity.linear_interpolate(target_velocity * DASH_MULTIPLIER, ACCELERATION * DASH_ACCEL_MULT * delta)
		motion = velocity * delta
		motion = move_and_slide(motion)

func is_dashing() -> bool:
	return dashing

func set_dashing(d: bool) -> void:
	
	if d == false:
		print("not dashing")
		dashing = d
		return

	dashing = d
	var dash_timeout = Timer.new()
	dash_timeout.connect("timeout", self, "set_dashing", [false])
	dash_timeout.wait_time = DASH_WAIT
	dash_timeout.one_shot = true
	add_child(dash_timeout)
	dash_timeout.start()
	print("dashing...")

func die() -> void:
	DEATH_SOUND.play()
	self.can_move = false
	self.visible = false
	yield(get_tree().create_timer(0.62), "timeout")
	Signals.emit_signal("level_failed")
