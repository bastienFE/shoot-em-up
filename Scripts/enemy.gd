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

	$Sprite2D.modulate = Color(1, getHealthRatio(), getHealthRatio())
	
	position.y -= received_knockback
	
	if health <= 0:
		die()

func die() -> void:
	var spark: Variant = load("res://Effects/explosion.tscn")
	var instance: Variant = spark.instantiate()

	instance.global_position = position

	get_tree().current_scene.add_child(instance)
	
	$DieSfx.play()
	
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
