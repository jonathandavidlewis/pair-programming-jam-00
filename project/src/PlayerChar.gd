extends KinematicBody2D

export(int) var MAX_VELOCITY = 10000 
export(int) var ACCELERATION = 5

var velocity = Vector2()


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var target_velocity = get_input_direction() * MAX_VELOCITY
	velocity = velocity.linear_interpolate(target_velocity, ACCELERATION * delta)
	move_and_slide(velocity * delta)

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


