extends Area2D

# name of laser class
class_name Laser

# speed of laser
@export var speed = 300

# called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# adjust vertical position by time elapsed after previous frame times speed
	position.y -= delta * speed
