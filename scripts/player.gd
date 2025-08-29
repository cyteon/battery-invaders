extends CharacterBody2D

var energy: float = 100.0
var batteries: int = 3
var score: int = 0

var still_colliding_with_wall: bool = false

func _input(event: InputEvent) -> void:
	if $CanvasLayer/GameOver.visible:
		return
	
	if event is InputEventMouseMotion:
		look_at(get_global_mouse_position())

func _physics_process(delta: float) -> void:
	if $CanvasLayer/GameOver.visible:
		return
	
	if Input.is_key_pressed(KEY_LEFT):
		rotation_degrees -= 5
	elif Input.is_key_pressed(KEY_RIGHT):
		rotation_degrees += 5
	
	var joystick_input = Input.get_vector("joystick_left", "joystick_right", "joystick_up", "joystick_down")
	
	if joystick_input != Vector2.ZERO:
		rotation = joystick_input.angle()
	
	if Input.is_action_pressed("boost") and energy > 0:
		energy -= 0.5
		
		var direction = Vector2(cos(rotation), sin(rotation)).normalized()
		velocity += direction * 50
		
		$EngineParticles.emitting = true
	else:
		$EngineParticles.emitting = false
	
	if Input.is_action_just_pressed("shoot") and energy > 0:
		if energy >= 5: energy -= 5
		else: energy = 0 # we will let people exhaust their energy to shoot, even if under 10
		
		var bullet = load("res://scenes/items/bullet.tscn").instantiate()
		bullet.global_position = global_position
		bullet.rotation = rotation
		
		$"../Bullets".add_child(bullet)
		$SFX/Shoot.play()
	
	if velocity.length() > 0:
		var friction = velocity.normalized() * 400 * delta
		
		if friction.length() > velocity.length():
			velocity = Vector2.ZERO
		else:
			velocity -= friction
	
	if velocity.length() > 400:
		velocity = velocity.normalized() * 400
		
	move_and_slide()
	
	var has_collided_with_wall: bool = false
	
	if get_slide_collision_count() > 0:
		for i in range(get_slide_collision_count()):
			var collider = get_slide_collision(i).get_collider()
			
			if collider.is_in_group("wall"):
				has_collided_with_wall = true
				
				if not still_colliding_with_wall:
					if energy > 10:
						energy -= 10
					else:
						damage(1)
					
					$SFX/Hit.play()
					
					still_colliding_with_wall = true
				
				var normal = get_slide_collision(i).get_normal()
				velocity += normal * 150
	
	if not has_collided_with_wall:
		still_colliding_with_wall = false
	
	if energy == 0:
		damage(1)
	
	$CanvasLayer/ProgressBar.value = energy
	$CanvasLayer/Batteries.size.x = batteries * 16
	
	$CanvasLayer/Score.text = str(score).lpad(6, "0")

func damage(v: int):
	energy -= v
	$SFX/Hit.play()
	
	if energy <= 0 and batteries > 0:
		batteries -= 1
		energy += 100
	
	if batteries <= 0 and energy <= 0:
		$CanvasLayer/Batteries.size.x = 0
		$EngineParticles.emitting = false
		$CanvasLayer/GameOver.show()
		$CanvasLayer/GameOver/Buttons/MenuMenuButton.grab_focus()
	
	$CanvasLayer/ProgressBar.value = energy
	$CanvasLayer/Batteries.size.x = batteries * 16

func _on_menu_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/menu.tscn")
