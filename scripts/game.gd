extends Node2D

var segment_len: int = 512
var segment_count: int = 20
var path_w: int = 300
var wall_thickness: int = 10
var rand: float = .4
var segments_ahead: int = 10
var last_path_center: Vector2 = Vector2.ZERO
var next_seg_y: int = 0

func _ready() -> void:
	for i in range(segments_ahead):
		_generate_next_segment(i)

func _process(delta: float) -> void:
	while $Player.global_position.y - 1000 < next_seg_y:
		print("generating")
		_generate_next_segment()

func _generate_next_segment(i: int = -1):
	var direction: Vector2
	
	if i > 1 or i == -1:
		direction = Vector2.UP.rotated(randf_range(-rand, rand)) * segment_len
	else:
		direction = Vector2.UP * segment_len
	
	var next_center = last_path_center + direction
	
	var left = create_wall_segment(
		last_path_center - Vector2(path_w / 2, 0),
		next_center - Vector2(path_w / 2, 0)
	)
	
	$Walls.add_child(left)
	
	var right = create_wall_segment(
		last_path_center + Vector2(path_w / 2, 0),
		next_center + Vector2(path_w / 2, 0)
	)
	
	$Walls.add_child(right)
	
	last_path_center = next_center
	next_seg_y = next_center.y
	
	if randi_range(0,2) == 1:
		var bat = load("res://scenes/items/battery.tscn").instantiate()
		bat.position = last_path_center + Vector2(randi_range(-100, 100), randi_range(-100, 100))
		
		$Items.add_child(bat)

func create_wall_segment(start: Vector2, end: Vector2) -> StaticBody2D:
	var wall = StaticBody2D.new()
	wall.add_to_group("wall")
	
	var col = CollisionPolygon2D.new()
	
	var dir = (end - start).normalized()
	var normal = dir.orthogonal() * wall_thickness
	
	var p = PackedVector2Array([
		start + normal,
		start - normal,
		end - normal,
		end + normal,
	])
	
	col.polygon = p
	wall.add_child(col)
	
	var spacing = 40
	var count = int(segment_len / spacing)
	
	for i in range(1, count):
		var t = float(i) / count
		var pos = start.lerp(end, t)
		
		var sprite = Sprite2D.new()
		
		var opts = [1, 1, 1, 2, 2, 2, 3] # make 3 rarer
		
		sprite.texture = load("res://assets/sprites/asteroid_%s.png" % opts[randi() % opts.size()])
		sprite.position = pos
		sprite.position.x += randi_range(-5, 5)
		sprite.rotation = dir.angle() + randf_range(-1, 1)
		sprite.scale = Vector2(2, 2)
		
		wall.add_child(sprite)
	
	return wall
