extends RigidBody2D

export(float) var COEFFICIENT_OF_FRICTION = 1

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# set_friction(COEFFICIENT_OF_FRICTION)
	pass # Replace with function body.

#func _physics_process(_delta):
#	var friction_force = -linear_velocity * friction
#	add_force(get_position(), friction_force)
	

func _integrate_forces(state):
	var linear_velocity = get_linear_velocity()
	var velocity_decrease = -linear_velocity * COEFFICIENT_OF_FRICTION
	# add_force(get_position(), friction_force)
	set_linear_velocity(linear_velocity + velocity_decrease)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
