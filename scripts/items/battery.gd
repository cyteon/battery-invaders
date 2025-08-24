extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.get_node("SFX/BatteryPickup").play()
		body.energy += 25
		queue_free()
