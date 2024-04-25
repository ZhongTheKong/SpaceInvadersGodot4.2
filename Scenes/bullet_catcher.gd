extends Area2D

# when something enters the bullet catcher area
func _on_area_entered(area):
	# not necessary to check area if using layers
	# destroy area that entered
	area.queue_free()
