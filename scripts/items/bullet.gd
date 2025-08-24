extends Area2D

var speed = 800

func _process(delta: float) -> void:
	position += transform.x * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and not body.dead:
		$"../../Player".score += 100
		body.kill()
		queue_free()
