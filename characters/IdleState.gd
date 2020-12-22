extends State

class_name IdleState


func _ready():
	print("IDLE")

func handle_input(event):
	if self.persistent_state.moving_left or self.persistent_state.moving_right:
		self.persistent_state.change_state("run")

## TODO Implement them

# func _physics_process(delta):
# 	var direction = self.persistent_state.get_direction()
# 	velocity = self.persistent_state.get_velocity(direction, delta)
# 	if self.persistent_state.is_jumping or self.persistent_state.rope:
# 		self.persistent_state.move_and_slide(velocity, Vector2.UP)
# 	else:
# 		self.persistent_state.move_and_slide_with_snap(velocity, self.persistent_state.snap_vector, Vector2.UP, false)

# func get_velocity(current_direction, delta):
# 	var current_velocity = self.velocity
# 	var v = current_velocity
# 	v.x = current_direction.x * SPEED

# 	if is_jumping:
# 		v.y = current_direction.y * jump_speed
# 	elif is_on_floor():
# 		v.y = 0.0
# 	elif v.y >= MAX_FALL_SPEED:
# 		v.y = MAX_FALL_SPEED
# 	else:
# 		v += (Vector2.DOWN * gravity/2) + (Vector2.DOWN * gravity * delta)

# 	if Input.is_key_pressed(KEY_T):
# 		print("velocity BEFORE rope pull force ", v)

# 	if self.rope:
# 		var rope_vector = to_local(self.rope.global_position)
# 		var rope_pull_vector = rope_vector.normalized() * (PULL_SPEED * (rope_vector.length() / self.rope.length) )
# 		v += rope_pull_vector

# 	return v

# func get_direction():
# 	var x_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

# 	if is_bouncing:
# 		x_dir = bounce_x_dir

# 	if Input.is_action_just_pressed("jump"):
# 		if self.rope:
# 			self.rope.queue_free()
# 			self.rope = null

# 		if (is_on_floor() or is_on_wall()) and not is_jumping:
# 			is_jumping = true
# 			jump_timer.start()

# 			if is_on_wall() and not is_on_floor() and get_slide_count():
# 				var collision = get_slide_collision(0)

# 				is_bouncing = true
# 				bounce_x_dir = collision.normal.x

# 				x_dir += bounce_x_dir
# 				bounce_timer.start()

# 	return Vector2(
# 		x_dir,
# 		-1 if is_jumping else 0
# 	).normalized()
