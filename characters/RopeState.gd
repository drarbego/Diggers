extends State

class_name RopeState

func _ready():
	print("rope")

func _physics_process(delta):
	if Input.is_action_just_pressed("jump"):
		self.persistent_state.change_state("jump")


	if not self.persistent_state.rope:
		self.persistent_state.change_state("idle")

	var rope_vec = self.persistent_state.rope.global_position - self.persistent_state.global_position
	var direction = rope_vec.normalized()

	self.persistent_state.velocity = self.get_velocity(direction, rope_vec.length())
	if Input.is_key_pressed(KEY_T):
		print("dist ", rope_vec.length())
		print("direction ", direction)
		print("self.persistent_state.velocity ", self.persistent_state.velocity)

	self.persistent_state.move_and_slide(self.persistent_state.velocity, Vector2.UP)

func get_velocity(current_direction, dist):
	var rope_pull_vector = current_direction.normalized() * (self.persistent_state.PULL_SPEED * (dist / self.persistent_state.rope.length))
	var v = rope_pull_vector + (Vector2.DOWN * self.persistent_state.gravity)

	return v
