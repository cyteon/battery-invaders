extends CharacterBody2D

@onready var player = $"../../Player"

var dead: bool = false

func _physics_process(delta: float) -> void:
	if dead:
		return
	
	look_at(player.global_position)
	
	$RayCast2D.target_position = to_local(player.global_position)
	
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		
		# sometimes collider was null? idk
		if collider && collider.is_in_group("player"):
			var direction = (player.global_position - global_position).normalized()
			velocity += direction * 25
	
	if velocity.length() > 0:
		var friction = velocity.normalized() * 400 * delta
		if friction.length() > velocity.length():
			velocity = Vector2.ZERO
		else:
			velocity -= friction

	if velocity.length() > 100:
		velocity = velocity.normalized() * 100
	
	move_and_slide()

func kill() -> void:
	$Polygon2D.hide()
	$Area2D.monitoring = false
	$CPUParticles2D.emitting = true
	dead = true
	
	collision_layer = 0
	collision_mask = 0
	
	if randi_range(0,1) == 0:
		var battery = load("res://scenes/items/battery.tscn").instantiate()
		battery.global_position = global_position
		$"../../Items".add_child(battery)

func _on_cpu_particles_2d_finished() -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.damage(1)
		kill()
	elif body.is_in_group("wall"):
		kill()
