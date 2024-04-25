extends CanvasLayer

# ready textures and labels
@onready var invader_1_texture = %Invader1Texture
@onready var invader_1_label = %Invader1Label
@onready var invader_2_texture = %Invader2Texture
@onready var invader_2_label = %Invader2Label
@onready var invader_3_texture = %Invader3Texture
@onready var invader_3_label = %Invader3Label
# ready timer
@onready var timer = $Timer

# array of invader information
var control_array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# array of invader 
	control_array.append_array([invader_1_texture, invader_1_label, invader_2_texture, invader_2_label, invader_3_texture, invader_3_label])
	
	# for everyting in the array of invader information
	for control in control_array:
		# make it transparent AKA invisible
		(control as Control).modulate = Color.TRANSPARENT

# function for loading the game
func load_game():
	# change to main scene
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func show_next_control():
	# get rid of first element of array
	var control = control_array.pop_front() as Control
	# if not at end of array
	if control != null:
		# change element to white AKA visible
		control.modulate = Color.WHITE
	# if at end of array
	else:
		# end timer for displaying start screen information
		timer.stop()
		# destroy timer child
		timer.queue_free()
