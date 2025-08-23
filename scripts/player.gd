extends CharacterBody2D

var energy: int = 100

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_at(get_global_mouse_position())

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("boost") and energy > 0:
		energy -= 1
		
		var direction = (get_global_mouse_position() - global_position).normalized()
		velocity += direction * 50
		
		$FireRed.emitting = true
		$FireOrange.emitting = true
	else:
		if $FireOrange.emitting or $FireRed.emitting:
			$FireRed.restart()
			$FireRed.emitting = false
			$FireOrange.restart()
			$FireOrange.emitting = false
	
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
