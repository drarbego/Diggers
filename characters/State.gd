extends Node2D

class_name State

var animated_sprite
var persistent_state

func setup(state):
	self.persistent_state = state

func handle_input(_event):
	pass
