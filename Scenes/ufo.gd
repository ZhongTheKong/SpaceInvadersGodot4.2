extends Area2D

# set class name
class_name Ufo

# speed constant
@export var speed = 200
# ready sprite
@onready var sprite_2d = $Sprite2D
# ready shooting point
@onready var shooting_point = $ShootingPoint
# load explosion texture
var explosion_texture = preload("res://Assets/Ufo/Ufo-explosion.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# change position
	position.x -= delta * speed

# if the ufo is not visible on screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	# destroy the ufo
	queue_free()

# function to check if an area enters the ufo
func _on_area_entered(area):
	# if the area is of Laser class
	if area is Laser:
		# destroy ufo's shooting point
		shooting_point.queue_free()
		# stop ufo speed
		speed = 0
		# change texture of ufo to explosion
		sprite_2d.texture = explosion_texture
		# wait until 1.5 second timer ends
		await get_tree().create_timer(1.5).timeout
		# destroy ufo
		queue_free()
