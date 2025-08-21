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
		_generate_next_segment()

func _process(delta: float) -> void:
	while $Player.global_position.y - 1000 < next_seg_y:
		print("generating")
		_generate_next_segment()

func _generate_next_segment():
	var direction = Vector2.UP.rotated(randf_range(-rand, rand)) * segment_len
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

func create_wall_segment(start: Vector2, end: Vector2) -> StaticBody2D:
	var wall = StaticBody2D.new()
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
	return wall
