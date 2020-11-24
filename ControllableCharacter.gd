extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SPEED = 200
const GRAVITY = 500
var MAX_FALL_SPEED = 200
var movement_dir = Vector2()
var x_axis = 0
var y_axis = 0
var velocity = Vector2.ZERO
onready var gravity = ProjectSettings.get("physics/2d/default_gravity") 


func _physics_process(delta):
	velocity.y += gravity * delta
	var direction = get_direction()
	velocity = get_velocity(velocity, direction)
	var snap_vector = Vector2.DOWN * 20
	move_and_slide_with_snap(velocity, snap_vector, Vector2.UP, false)

func get_velocity(current_velocity, current_direction):
	var v = current_velocity
	v.x = current_direction.x * SPEED
	if is_on_floor():
		v.y = 0.0
	if v.y > MAX_FALL_SPEED:
		v.y = MAX_FALL_SPEED
	return v

func get_direction():
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") if is_on_floor() else 0,
		-1 if Input.is_action_just_released("jump") and is_on_floor() else 0
	).normalized()
