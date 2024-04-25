extends CanvasLayer

var life_texture = preload("res://Assets/Player/Player.png")

# reference container
@onready var lifes_ui_container = $MarginContainer/HBoxContainer
# reference label
@onready var points_label = $MarginContainer/Points
# reference nodes as classes
@onready var points_counter = $"../PointsCounter" as PointsCounter
@onready var life_manager = $"../LifeManager" as LifeManager
@onready var invader_spawner = $"../InvaderSpawner" as InvaderSpawner
# reference label
@onready var game_over_label = %GameOverLabel
# reference button
@onready var game_over_button = %GameOverButton
# reference container
@onready var game_over_container = $MarginContainer/GameOverContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	# initialize text to display score of 0
	points_label.text = "SCORE: %d" % 0
	# connect functions
	# on_points_increased signal of points_counter calls points_increased function
	points_counter.on_points_increased.connect(points_increased)
	# game_lost signal of invader_spawner calls on_game_lost function
	invader_spawner.game_lost.connect(on_game_lost)
	# game_won signal of invader_spawner calls on_game_won function
	invader_spawner.game_won.connect(on_game_won)
	# pressed signal of game_over_button calls on_restart_button_pressed function
	game_over_button.pressed.connect(on_restart_button_pressed)
	# life_lost signal of life_manager calls on_life_lost function
	life_manager.life_lost.connect(on_life_lost)
	
	# for the number of lives
	for i in range(life_manager.lifes):
		# create new texture area
		var life_texture_rect = TextureRect.new()
		# expand size
		life_texture_rect.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		life_texture_rect.custom_minimum_size = Vector2(40,25)
		# texture put on nearest instead of inherit
		life_texture_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		# set texture to player texture
		life_texture_rect.texture = life_texture
		# add to container
		lifes_ui_container.add_child(life_texture_rect)
	
# called when points increase
func points_increased(points: int):
	# change text of points label
	points_label.text = "SCORE: %d" % points

# called when game is lost
func on_game_lost():
	# make game over container visible
	# displays game lost text by default
	game_over_container.visible = true

# called when game is won
func on_game_won():
	# change game over text
	game_over_label.text = "YOU WON!"
	# change color of text to green
	game_over_label.add_theme_color_override("font_color", Color.GREEN)
	# make game over container visible
	game_over_container.visible = true

# called when GameOverButton is pressed
func on_restart_button_pressed():
	# reload scene
	get_tree().reload_current_scene()
	
# called when life is lost
func on_life_lost(lifes_left: int):
	# if there are still lives left
	if lifes_left != 0:
		# get the top right container that has the indicator for lives
		# use lifes_left as index for the player icon container
		var life_texture_rect = lifes_ui_container.get_child(lifes_left)
		# get rid of player life container
		life_texture_rect.queue_free()
	else:
		# call game lost
		on_game_lost()
