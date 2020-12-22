extends Node2D

class_name State

var change_state : FuncRef
var animated_sprite
var persistent_state
var velocity

func _physics_process(_delta):
	persistent_state.move_and_slide(persistent_state.velocity, Vector2.UP)

func setup(animated_sprite, persistent_state):
	self.animated_sprite = animated_sprite
	self.persistent_state = persistent_state

func handle_input(event):
	pass
