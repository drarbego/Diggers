extends Node2D


var link_class = preload("res://weapons/ChainLink.tscn")
var capsule_radius = 2
var capsule_height = 70
var to_pos = null
var triggerer = null
var length = null
var rope_delta = null

func _ready():
	# _generate_rope()
	length = to_local(triggerer.global_position).length()
	triggerer.rope = self

func _generate_rope():
	var rope_orientation_vector = (to_pos - self.global_position).normalized()
	var rope_step_vector = rope_orientation_vector * capsule_height

	var dist = (to_pos - self.global_position).length()
	var steps = int(dist / capsule_height)
	var prev_shape = $StaticBody2D

	var _pos = self.global_position
	for _i in range(steps):
		var joint = PinJoint2D.new()
		add_child(joint)

		var new_shape = link_class.instance()
		add_child(new_shape)
		_pos += rope_step_vector
		new_shape.global_position = prev_shape.global_position + rope_step_vector

		joint.global_position = prev_shape.global_position + rope_step_vector / 2
		joint.node_a = prev_shape.get_path()
		joint.node_b = new_shape.get_path()

		prev_shape = new_shape

func _unhandled_input(event):
	if event.is_action_pressed("ui_up"):
		self.rope_delta = -5
	if event.is_action_pressed("ui_down"):
		self.rope_delta = 5
	if event.is_action_released("ui_up") or event.is_action_released("ui_down"):
		self.rope_delta = null

func _draw():
	draw_line(Vector2.ZERO, to_local(self.triggerer.global_position), Color(0.5, 0, 0.5))

func _process(delta):
	update()
	if self.rope_delta != null:
		self.length = clamp(self.length + rope_delta, 10, INF)