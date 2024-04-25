extends Node

# set name of LifeManager class
class_name LifeManager

# signal for when life is lost
signal life_lost(lifes_left: int)

# set number of lives
@export var lifes = 3
# have player class instance on ready
@onready var player: Player = $"../Player"
# load player
var player_scene = preload("res://Scenes/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# when Player class' player_destroyed signal is emitted, call on_player_destroyed function
	(player as Player).player_destroyed.connect(on_player_destroyed)

# function for when player is destroyed
func on_player_destroyed():
	# decrement number of lives
	lifes -= 1
	# emit life_lost signal with number of lives parameter
	life_lost.emit(lifes)
	# if there are still lives left
	if lifes != 0:
		# create new player scene
		player = player_scene.instantiate() as Player
		# set position to x=0 y=302
		player.global_position = Vector2(0,302)
		# when player_destroyed signal from Player class is emitted, on_player_destroyed function is called
		player.player_destroyed.connect(on_player_destroyed)
		# add player to main scene
		get_tree().root.get_node("main").add_child(player)
