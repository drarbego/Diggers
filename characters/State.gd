extends Node2D

class_name State

var animated_sprite
var persistent_state

func setup(sprite, state):
	self.animated_sprite = sprite
	self.persistent_state = state

func handle_input(_event):
	pass
