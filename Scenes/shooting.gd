extends Node2D

class_name Shooting

# load laser scene
@export var laser_scene = preload("res://Scenes/laser.tscn")

# player allowed to shoot variable
var can_player_shoot = true
var player_in_death_animation = false

# function to check for input
func _input(_event):
	
	# if the action was shoot and the player is allowed to shoot
	if Input.is_action_just_pressed("shoot") && can_player_shoot:
		
		#FAILED CODE
		#if Input.is_action_just_pressed("shoot"):
			#var laser = laser_scene.instantiate() as Laser
		
			#laser.global_position = get_parent().global_position + Vector2(0,-20)
			#get_tree().root.get_node("main").add_child(laser)
		#END FAILED CODE
		
		# Instantiate the laser scene
		var laser = laser_scene.instantiate()
		
		# check if the instantiation was successful
		if laser:
			# disable shooting
			can_player_shoot = false
			# Set the position of the laser instance
			laser.global_position = get_parent().global_position + Vector2(0, -20)
			# Add the laser instance as a child to the main node
			get_tree().root.get_node("main").add_child(laser)
			# When laser is destroyed
			laser.tree_exited.connect(on_laser_destroyed)
		# if instantiation was unsuccessful
		else:
			# print error message
			print("Error: Failed to instantiate laser scene.")

# function for when laser is destroyed
func on_laser_destroyed():
	if !player_in_death_animation:
		# allow player to shoot again
		can_player_shoot = true


func _on_animation_player_animation_started(anim_name):
	if anim_name == "destroy":
		player_in_death_animation = true
