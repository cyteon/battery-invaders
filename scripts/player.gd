extends CharacterBody2D

var energy: int = 100
var hearts: int = 3
var still_colliding_with_wall: bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_at(get_global_mouse_position())

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("boost") and energy > 0:
		energy -= 1
		
		var direction = (get_global_mouse_position() - global_position).normalized()
		velocity += direction * 50
		
		$EngineParticles.emitting = true
	else:
		$EngineParticles.emitting = false
	
	if velocity.length() > 0:
		var friction = velocity.normalized() * 400 * delta
		
		if friction.length() > velocity.length():
			velocity = Vector2.ZERO
		else:
			velocity -= friction
	
	if velocity.length() > 800:
		velocity = velocity.normalized() * 800
		
	move_and_slide()
	
	var has_collided_with_wall: bool = false
	
	if get_slide_collision_count() > 0:
		for i in range(get_slide_collision_count()):
			var collider = get_slide_collision(i).get_collider()
			
			if collider.is_in_group("wall"):
				has_collided_with_wall = true
				
				if not still_colliding_with_wall:
					damage(1)
					still_colliding_with_wall = true
	
	if not has_collided_with_wall:
		still_colliding_with_wall = false
	
	$CanvasLayer/ProgressBar.value = energy
	$CanvasLayer/Hearts.size.x = hearts * 16

func damage(v: int):
	hearts -= v
