@tool
## A 2D arc
class_name Arc2D
extends Line2D

# ##################################################################################################
# Variable declaration
# ##################################################################################################

@export var bend_strength:int = 10:
	set(value):
		bend_strength = value
		_setup_arc_static()
		
@export_enum("Left", "Right") var bend_direction:String = "Right":
	set(value):
		bend_direction = value
		_setup_arc_static()
		
@export var smoothness:int = 10:
	set(value):
		smoothness = value
		_setup_arc_static()

var _start:Vector2
var _end:Vector2
var _midpoint:Vector2
var _arc_midpoint:Vector2

var _last_start_position:Vector2
var _last_end_position:Vector2

# ##################################################################################################
# Game loop
# ##################################################################################################

@warning_ignore("unused_parameter")
func _process(delta):
	_setup_arc_flexible()

# ##################################################################################################
# Checks
# ##################################################################################################

func _is_position_the_same() -> bool:
	return _start == _last_start_position and _end == _last_end_position

# ##################################################################################################
# Functions
# ##################################################################################################

func _setup_arc_static():
	_set_extreme_points()
	_reset_points()
	_set_midpoints()
	_set_arc_segments()
	
	
func _setup_arc_flexible():
	if points.size() < 2:
		return
		
	_set_extreme_points()
	
	if _is_position_the_same():
		return
	
	_reset_points()
	_set_midpoints()
	_set_arc_segments()
	
	
func _set_extreme_points():
	_start = points[0]
	_end = points[points.size() - 1]
	
	
func _reset_points():
	_last_start_position = _start
	_last_end_position = _end
	
	clear_points()


func _set_midpoints():
	_midpoint = (_start + _end) / 2
	_arc_midpoint = _midpoint + _get_bend_direction()


func _get_bend_direction() -> Vector2:
	if bend_direction == "Left":
		return Vector2(_start.y - _midpoint.y, _midpoint.x - _start.x).normalized() * bend_strength * 5
		
	return Vector2(_midpoint.y - _start.y, _start.x - _midpoint.x).normalized() * bend_strength * 5
	

func _set_arc_segments():
	add_point(_start, 0)
	
	for segment in range(1, smoothness - 1):
		add_point(_interpolate_arc_point(float(segment) / float(smoothness - 1)), segment)
		
	add_point(_end, smoothness - 1)


func _interpolate_arc_point(segment:float) -> Vector2:
	var interpolated_point1:Vector2 = _start.lerp(_arc_midpoint, segment)
	var interpolated_point2:Vector2 = _arc_midpoint.lerp(_end, segment)
	
	return interpolated_point1.lerp(interpolated_point2, segment)
