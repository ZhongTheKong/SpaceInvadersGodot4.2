extends Area2D

# class name
class_name InvaderShot

# speed of invader shot
@export var speed = 200

# called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# vertical position goes down every frame
	position.y += speed * delta

# when invader shot is no longer visible on the screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	# destroy invader shot
	queue_free()

# when invader shot enters an area
func _on_area_entered(area):
	# if the area is a player
	if area is Player:
		# call on_player_destroyed function from Player class
		(area as Player).on_player_destroyed()
		# destroy the player area
		queue_free()
