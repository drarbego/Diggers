extends Node2D

var projectile_class = preload("res://weapons/Arrow.tscn")
var SPEED = 700

func get_projectile():
	return projectile_class.instance()
