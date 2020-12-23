extends State

class_name IdleState

const SPEED = 500
var MAX_FALL_SPEED = 1000
var movement_dir = Vector2()
var x_axis = 0
var y_axis = 0
var velocity = Vector2.ZERO
onready var gravity = ProjectSettings.get("physics/2d/default_gravity")
var can_jump = true
var jump_speed = 2000
var is_jumping = false
var is_bouncing = false
var bounce_x_dir = 0
onready var PULL_SPEED = gravity
var snap_vector = Vector2.DOWN * 20

func _ready():
	print("IDLE")

func handle_input(_event):
	if self.persistent_state.moving_left or self.persistent_state.moving_right:
		self.persistent_state.change_state("run")

## TODO Implement them

func _physics_process(delta):
	var direction = self.get_direction()
	velocity = self.get_velocity(direction, delta)
	if self.is_jumping or self.persistent_state.rope:
		self.persistent_state.move_and_slide(velocity, Vector2.UP)
	else:
		self.persistent_state.move_and_slide_with_snap(velocity, self.snap_vector, Vector2.UP, false)

func get_velocity(current_direction, delta):
	var current_velocity = self.velocity
	var v = current_velocity
	v.x = current_direction.x * SPEED

	if is_jumping:
		v.y = current_direction.y * jump_speed
	elif self.persistent_state.is_on_floor():
		v.y = 0.0
	elif v.y >= MAX_FALL_SPEED:
		v.y = MAX_FALL_SPEED
	else:
		v += (Vector2.DOWN * gravity/2) + (Vector2.DOWN * gravity * delta)

	if Input.is_key_pressed(KEY_T):
		print("velocity BEFORE rope pull force ", v)

	if self.persistent_state.rope:
		var rope_vector = to_local(self.persistent_state.rope.global_position)
		var rope_pull_vector = rope_vector.normalized() * (PULL_SPEED * (rope_vector.length() / self.persistent_state.rope.length) )
		v += rope_pull_vector

	return v

func get_direction():
	var x_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if is_bouncing:
		x_dir = bounce_x_dir

	if Input.is_action_just_pressed("jump"):
		if self.rope:
			self.rope.queue_free()
			self.rope = null

		if (self.persistent_state.is_on_floor() or self.persistent_state.is_on_wall()) and not is_jumping:
			is_jumping = true

			if self.persistent_state.is_on_wall() and not self.persistent_state.is_on_floor() and self.persistent_state.get_slide_count():
				var collision = self.persistent_state.get_slide_collision(0)

				is_bouncing = true
				bounce_x_dir = collision.normal.x

				x_dir += bounce_x_dir

	return Vector2(
		x_dir,
		-1 if is_jumping else 0
	).normalized()
