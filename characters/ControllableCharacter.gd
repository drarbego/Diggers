extends KinematicBody2D

class_name ControllableCharacter

var moving_right = false
var moving_left = false
var rope = null

const SPEED = 500
var MAX_FALL_SPEED = 1000
var velocity = Vector2.ZERO
var can_jump = true
var jump_speed = 2000
var is_jumping = false
var is_bouncing = false
var bounce_x_dir = 0
onready var gravity = ProjectSettings.get("physics/2d/default_gravity")
onready var PULL_SPEED = gravity
var snap_vector = Vector2.DOWN * 20

onready var state_factory = StateFactory.new()
var state

func _unhandled_input(event):
	if event.is_action_pressed("ui_right"):
		moving_right = true
	if event.is_action_released("ui_right"):
		moving_right = false

	if event.is_action_pressed("ui_left"):
		moving_left = true
	if event.is_action_released("ui_left"):
		moving_left = false

	self.state.handle_input(event)

func change_state(state_name):
	if is_instance_valid(self.state):
		self.state.queue_free()
	self.state = self.state_factory.get_state(state_name).new()
	state.setup($AnimatedSprite, self)
	state.name = "current_state"
	add_child(state)

func _ready():
	self.change_state("idle")

func _process(_delta):
	update()
