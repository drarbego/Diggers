extends KinematicBody2D

class_name ControllableCharacter



var moving_right = false
var moving_left = false
var rope = null

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
	if is_instance_valid(state):
		self.state.queue_free()
	self.state = self.state_factory.get_state(state_name).new()
	state.setup($AnimatedSprite, self)
	state.name = "current_state"
	add_child(state)

func _ready():
	self.change_state("idle")

func _process(_delta):
	update()
