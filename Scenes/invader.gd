extends Area2D

class_name Invader

# signal for when invader is destroyed
signal invader_destroyed(points: int)

# config uses resource folder
var config: Resource

# have animation and sprite on hand
@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	#FIXED sprite_1 not sprite
	
	# NOTE: make sure to run program from main scene or else Godot won't recognize sprite_1
	
	# set texture to sprite_1 texture in invader config
	sprite_2d.texture = config.sprite_1
	# set and play animation to animation_name animation in invader config
	animation_player.play(config.animation_name)
	
	# ERROR CHECKING TEST CODE
	#====================================================
	#sprite_2d.texture = config.sprite_1
	#animation_player.play(config.animation_name)
	#if config:
		##print("Config is not null.")
		#if config.has("sprite_1"):
			##print("Sprite 1 exists in config.")
			#sprite_2d.texture = config.sprite_1
			#animation_player.play(config.animation_name)
		#else:
			#print("Sprite 1 does not exist in config.")
	#else:
		#print("Config is null.")
	#=====================================================

# when an area enters the invader's area
func _on_area_entered(area):
	# check that area entering invader is laser
	if area is Laser:
		# play destroy animation
		animation_player.play("destroy")
		# free laser area
		area.queue_free()

# when animation finishes
func _on_animation_player_animation_finished(anim_name):
	# if animation is destroy animation
	if anim_name == "destroy":
		# free invader
		queue_free()
		# signal that the invader is destroyed and emit the points from invader config
		invader_destroyed.emit(config.points)
