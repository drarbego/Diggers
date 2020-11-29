extends Node2D

var bullet_class = preload("res://weapons/Bullet.tscn")
var SPEED = 500.0

func get_bullet():
    var bullet = bullet_class.instance()
    return bullet

