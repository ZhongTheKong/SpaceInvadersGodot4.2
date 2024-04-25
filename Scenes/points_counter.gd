extends Node

# create class name for PointsCounter
class_name PointsCounter

# signal for when points increase
signal on_points_increased(points: int)
# create variable to store points and initialize it to 0
var points = 0
# ready invader spawner class instance
@onready var invader_spawner = $"../InvaderSpawner" as InvaderSpawner

# Called when the node enters the scene tree for the first time.
func _ready():
	# when invader destroyed signal from invader_spawner class is emitted, call increase_points function
	invader_spawner.invader_destroyed.connect(increase_points)

# function for increasing points
func increase_points(points_to_add: int):
	# add to points
	points += points_to_add
	# emit signal for points being increased
	on_points_increased.emit(points)
