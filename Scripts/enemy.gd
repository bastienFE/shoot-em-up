class_name Enemy
extends Area2D

@export var max_speed: float = 300.0
@export var max_health: int = 15
@export var received_knockback: int = 20

var health: int

func _ready() -> void:
	health = max_health

# renvoi le ratio de vie / vie_max pour changer la couleur en fonction de la vie
func getHealthRatio() -> float:
	return float(health) / max_health

func takeDamage(damage: int) -> void:
	health -= damage
	GameManager.add_score(10.0)

	$Sprite2D.modulate = Color(1, getHealthRatio(), getHealthRatio())
	
	position.y -= received_knockback
	
	if health <= 0:
		die()

func die() -> void:
	var explosion: Variant = load("res://Effects/explosion.tscn")
	var rocks: Variant = load("res://Effects/debris.tscn")
	var explInstance: Variant = explosion.instantiate()
	var rocksInstance: Variant = rocks.instantiate()

	explInstance.global_position = position
	rocksInstance.global_position = position

	get_tree().current_scene.add_child(explInstance)
	get_tree().current_scene.add_child(rocksInstance)
	
	GameManager.add_score(200.0)
	get_viewport().get_camera_2d().add_trauma(0.1)
	
	# un ralentit comme dans les Killing Floors avec 10% de chance quand un ennemi meurt
	if randf_range(0, 1.0) < 0.1:
		GameManager.hitStop(10, 0.5)
	else:
		GameManager.hitStop(0.5, 0.01)
	
	queue_free()

func current_speed() -> float:
	return max_speed * (max_health / max(health, 1))

func _physics_process(delta: float) -> void:
	position.y += current_speed() * delta
	position.x += cos(position.y / 50) * 50 * delta
	
	if position.y > 1280 + $Sprite2D.texture.get_height():
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("takeDamage"):
		body.takeDamage(1)
		queue_free()
