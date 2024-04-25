extends Area2D

# get starting texture
# NOTE: duplicating script will use old starting sprite. Should change to current bunker part's sprite
@export var sprite: Sprite2D
# get array of alternate textures
@export var texture_array: Array[Texture2D]

# initialize damage
var damage = 0
# set constant max damage
const MAX_DAMAGE = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	# connect function
	self.area_entered.connect(_on_area_entered)

# function for when an area enters the bunker
func _on_area_entered(area):
	# if area is player laser or invader shot
	if area is Laser || area is InvaderShot:
		# destroy area
		area.queue_free()
		# check damage is not at max
		if damage < MAX_DAMAGE:
			# increase damage by 1
			damage += 1
			# adjust texture to be a higher damage using the texture array
			sprite.texture = texture_array[damage - 1]
		# if damage is at max
		else:
			# destroy bunker part
			queue_free()
	# if area is invader
	if area is Invader:
		# destroy bunker part
		queue_free()
