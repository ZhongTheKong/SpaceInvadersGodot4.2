extends Timer

# used in ufo_shooting.gd and ufo_spawner.gd

# set class name
class_name SpawnTimer

# set
@export var min_timer = 5
@export var max_timer = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	# call setup_timer function
	setup_timer()

# function to create timer
func setup_timer():
	# random time
	var random_time = randi_range(min_timer, max_timer)
	self.wait_time = random_time
	# restart timer
	self.stop()
	self.start()
