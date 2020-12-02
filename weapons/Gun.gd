extends Node2D

var projectile_class = preload("res://weapons/Bullet.tscn")
var SPEED = 1000.0

func get_projectile():
    var bullet = projectile_class.instance()
    return bullet

