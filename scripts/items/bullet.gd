extends Area2D

var speed = 800

func _process(delta: float) -> void:
	position += transform.x * speed * delta
