extends Node2D

@onready var spawn_timer = $SpawnTimer
var ufo_scene: PackedScene = preload("res://Scenes/ufo.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# start random 5-10 second spawner
	(spawn_timer as SpawnTimer).setup_timer()

# function for when timer times out
func _on_spawn_timer_timeout():
	# create ufo scene instance
	var ufo = ufo_scene.instantiate()
	# set spawn position
	ufo.global_position = position
	# add ufo to main scene
	get_tree().root.add_child(ufo)
