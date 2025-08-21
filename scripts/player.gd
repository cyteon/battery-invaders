extends CharacterBody2D

var energy: int = 10000

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_at(get_global_mouse_position())
	
	if event.is_action("boost") and energy > 0:
		energy -= 1
		
		var direction = (get_global_mouse_position() - global_position).normalized()
		velocity += direction * 150

func _physics_process(delta: float) -> void:
	if velocity.length() > 0:
		var friction = velocity.normalized() * 400 * delta
		
		if friction.length() > velocity.length():
			velocity = Vector2.ZERO
		else:
			velocity -= friction
	
	if velocity.length() > 800:
		velocity = velocity.normalized() * 800
	
	$CanvasLayer/ProgressBar.value = energy
	
	move_and_slide()
