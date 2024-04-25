extends Node2D

# ready the random 5-10 second spawn timer
@onready var spawn_timer: SpawnTimer = $SpawnTimer
# load invader shot/bullet scene
var projectile_scene = preload("res://Scenes/invader_shot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# create timer instance
	(spawn_timer as SpawnTimer).setup_timer()
	# if spawn timer ends, call on_spawn_timer_timeout function
	spawn_timer.timeout.connect(on_spawn_timer_timeout)

# function for when bullet spawner ends
func on_spawn_timer_timeout():
	# create bullet
	var projectile = projectile_scene.instantiate()
	# get bullet sprite
	var projectile_sprite = projectile.get_node("Sprite2D") as Sprite2D
	# change bullet sprite color
	projectile_sprite.modulate = Color(0.67, 0.2, 0.2, 1)
	# set starting position
	projectile.global_position = global_position
	# add projectile to main scene
	get_tree().root.add_child(projectile)
	# restart timer
	spawn_timer.setup_timer()
