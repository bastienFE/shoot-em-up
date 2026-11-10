extends Area2D

@export var speed: float = 1200.0
@export_range(0, PI, PI / 180) var rotation_range: float = 3 * PI / 180

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation = randf_range(-rotation_range, rotation_range)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#position.y -= SPEED * delta
	position += Vector2.UP.rotated(rotation) * speed * delta
	
	if position.y <= -$Sprite2D.texture.get_height():
		queue_free()



func _on_area_entered(area: Area2D) -> void:
	if area.has_method("takeDamage"):
		area.takeDamage(1)
		var spark: Variant = load("res://Effects/hit_spark.tscn")
		var instance: Variant = spark.instantiate()

		instance.global_position = position
		instance.rotation = PI
		instance.scale = Vector2(2.0, 3.0)

		get_tree().current_scene.add_child(instance)
		queue_free()
