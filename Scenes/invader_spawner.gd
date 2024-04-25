extends Node2D

# create class name
class_name InvaderSpawner

# create signals
signal invader_destroyed(points: int)
signal game_won
signal game_lost

# spawner configuration
# number of invaders
const ROWS = 5
const COLUMNS = 11
# spacing
const HORIZONTAL_SPACING = 32
const VERTICAL_SPACING = 32
# size
const INVADER_HEIGHT = 24
# starting position
const START_Y_POSITION = -50
# movement increments
const INVADERS_POSITION_X_INCREMENT = 10
const INVADERS_POSITION_Y_INCREMENT = 20
# direction set to right by default
var movement_direction = 1
# invader
var invader_scene = preload("res://Scenes/invader.tscn")
# invader shot
var invader_shot_scene = preload("res://Scenes/invader_shot.tscn")
# number of invaders destroyed
var invader_destroyed_count = 0
# number of invaders
var invader_total_count = ROWS * COLUMNS
# NODE REFERENCES
# timer for movement
@onready var movement_timer = $MovementTimer
# timer for shooting
@onready var shot_timer = $ShotTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	# SETUP TIMERS
	# when movement timer finishes call move_invaders function
	movement_timer.timeout.connect(move_invaders)
	# when shot timer finishes call on_invader_shot function
	shot_timer.timeout.connect(on_invader_shot)
	
	# Load all invader resources
	var invader_1_resource = preload("res://Resources/invader_1.tres")
	var invader_2_resource = preload("res://Resources/invader_2.tres")
	var invader_3_resource = preload("res://Resources/invader_3.tres")
	# empty invader config file
	var invader_config
	# for all the rows
	for row in range(ROWS):
		# first row
		if row == 0:
			# use first invader resource
			invader_config = invader_1_resource
		# second and third row
		elif row == 1 || row == 2:
			# use second invader resource
			invader_config = invader_2_resource
		# fourth and fifth row
		elif row == 3 || row == 4:
			# use third invader resource
			invader_config = invader_3_resource
		
		# calculate row width with horizontal spacing and invader size
		var row_width = ((COLUMNS * invader_config.width * 3) + (COLUMNS - 1) * HORIZONTAL_SPACING)
		# set starting position as center x minus size of row divided by 2
		var start_x = (position.x - row_width) / 2
		
		# spawning in invaders
		# for all the columns
		for col in range(COLUMNS):
			# spawn x position
			var x = start_x + (col * invader_config.width * 3) + (col * HORIZONTAL_SPACING)
			# spawn y position
			var y = START_Y_POSITION + (row * INVADER_HEIGHT) + (row * VERTICAL_SPACING)
			# set spawn position
			var spawn_position = Vector2(x, y)
			# spawn invader using spawn_invader function
			spawn_invader(invader_config, spawn_position)

# spawn invader function, takes invader config and spawn position
func spawn_invader(invader_config, spawn_position: Vector2):
	# create invader scene
	var invader = invader_scene.instantiate() as Invader
	# set invader config
	invader.config = invader_config
	# set position to spawn_position
	invader.global_position = spawn_position
	# invader_destroyed signal from invader calls on_invader_destroyed function
	invader.invader_destroyed.connect(on_invader_destroyed)
	# add invader to main scene
	add_child(invader)

# function to move invaders
func move_invaders():
	# increment position using movement in the current direction
	position.x += INVADERS_POSITION_X_INCREMENT * movement_direction

# when invaders enter the right wall
func _on_right_wall_area_entered(_area):
	if (movement_direction == 1):
		# move down
		position.y += INVADERS_POSITION_Y_INCREMENT
		# reverse direction
		movement_direction *= -1

# when invaders enter the left wall
func _on_left_wall_area_entered(_area):
	if (movement_direction == -1):
		# move down
		position.y += INVADERS_POSITION_Y_INCREMENT
		# reverse direction
		movement_direction *= -1

# when invader shoots
func on_invader_shot():
	# get an array of children
	# only get invader children not timer children
	# get the positions of all the invaders
	# pick a random position
	var random_child_position = get_children().filter(func (child): return child is Invader).map(func (invader): return invader.global_position).pick_random()
	# create invader shot scene
	var invader_shot = invader_shot_scene.instantiate() as InvaderShot
	# set position to the random position
	invader_shot.global_position = random_child_position
	# add shot to main scene
	get_tree().root.add_child(invader_shot)

# when invader is destroyed
func on_invader_destroyed(points: int):
	# call invader_destroyed signal and pass points
	invader_destroyed.emit(points)
	# increment number of invaders destroyed
	invader_destroyed_count += 1
	# if number of invaders destroyed is equal to total number of invaders spawned
	if invader_destroyed_count == invader_total_count:
		# signal that game was won
		game_won.emit()
		# stop shot_timer
		shot_timer.stop()
		# stop movement_timer
		movement_timer.stop()
		# change direction to 0
		movement_direction = 0

# when invaders reach bottom of screen
func _on_bottom_wall_area_entered(_area):
	# signal that game was lost
	game_lost.emit()
	# stop shot_timer
	shot_timer.stop()
	# stop movement_timer
	movement_timer.stop()
	# change direction to 0
	movement_direction = 0
