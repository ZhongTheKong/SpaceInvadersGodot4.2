extends Area2D

class_name Player

# player destroyed signal
signal player_destroyed

# speed constant
@export var speed = 200
# direction vector
var direction = Vector2.ZERO

# ready CollisionShape2D
@onready var collision_rect: CollisionShape2D = $CollisionShape2D
# ready AnimationPlayer
@onready var animation_player = $AnimationPlayer
# ready shot origin
@onready var shot_origin = $ShotOrigin

# initialize variables
var bounding_size_x
var start_bound
var end_bound

# Called when the node enters the scene tree for the first time.
func _ready():
	# set up camera
	bounding_size_x = collision_rect.shape.get_rect().size.x
	# get the viewport of the current scene
	var rect = get_viewport().get_visible_rect()
	var camera = get_viewport().get_camera_2d()
	# set camera_position to the camera's position
	var camera_position = camera.position
	# set boundries
	start_bound = (camera_position.x - rect.size.x) / 2
	end_bound = (camera_position.x + rect.size.x) / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# set right direction to positive value and left direction to negative value
	var input = Input.get_axis("move_left", "move_right")
	# move right
	if input > 0:
		direction = Vector2.RIGHT
	# move left
	elif input < 0:
		direction = Vector2.LEFT
	# don't move
	else:
		direction = Vector2.ZERO
	
	# get distance moved
	var delta_movement = speed * delta * direction.x
	
	# are we going out of screen bounds?
	if (position.x + delta_movement < start_bound + bounding_size_x * transform.get_scale().x ||
		position.x + delta_movement > end_bound - bounding_size_x * transform.get_scale().x):
		return
	
	# apply distance moved
	position.x += delta_movement

# when player is destroyed
func on_player_destroyed():
	# stop movement
	speed = 0
	
	# disable shooting after play is destroyed
	# CURRENT ISSUE WITH LASER AFTER DEATH RENABLING ABILITY TO SHOOT
	(shot_origin as Shooting).can_player_shoot = false;
	
	# play destruction animation
	animation_player.play("destroy")
	

# after player destruction animation
func _on_animation_player_animation_finished(anim_name):
	# make sure the animation is the destruction animation
	if anim_name == "destroy":
		# wait 1 second before doing anything
		await get_tree().create_timer(1).timeout
		# signal that player was destroyed
		player_destroyed.emit()
		# get rid of player scene
		queue_free()
