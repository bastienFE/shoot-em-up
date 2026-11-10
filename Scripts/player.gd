extends CharacterBody2D

@onready var invincibilityTimer: Timer = $Invincibility

@export var ACCELERATION: float = 70.0
@export var MAX_HEALTH: int = 3.0
const MOUSE_DEAD_ZONE: float = 10.0

var speed: float = 0.0
var health: int
var invincible: bool = false

func accelerate(acceleration: float) -> void:
	speed += acceleration
	GameManager.player_move.emit(speed)

func moveRotation() -> void:
	$Sprite2D.rotation = sin(speed / 1000)
	GameManager.player_move.emit(speed)

func decelerate() -> void:
	speed *= 0.9

func takeDamage(damage: int) -> void:
	if invincible:
		return

	health -= damage
	
	invincible = true
	invincibilityTimer.start()
	var blinkTween: Tween = get_tree().create_tween()
	blinkTween.tween_property($Sprite2D, "modulate:a", 0.1, 0.25)
	blinkTween.tween_property($Sprite2D, "modulate:a", 1, 0.25)
	
	blinkTween.set_loops(2)
	blinkTween.play()

	GameManager.player_life_changed.emit(health)
	GameManager.hitStop(1, 0.05)
	
	$HurtSfx.pitch_scale = randf_range(0.7, 1.25)
	$HurtSfx.play()
	
	if health <= 0:
		var spark: Variant = load("res://Effects/explosion.tscn")
		var instance: Variant = spark.instantiate()

		instance.global_position = position

		get_tree().current_scene.add_child(instance)
		
		GameManager.trigger_game_over()
		
		queue_free()

func _ready() -> void:
	health = MAX_HEALTH

func _physics_process(delta: float) -> void:
	var direction: Variant = Input.get_axis("move_left", "move_right")

	if Input.is_action_pressed("touch"):
		if getDistanceToFinger().x < -MOUSE_DEAD_ZONE:
			accelerate(-ACCELERATION)
		elif getDistanceToFinger().x > MOUSE_DEAD_ZONE:
			accelerate(ACCELERATION)
	elif direction:
		accelerate(ACCELERATION * direction)


	decelerate()

	velocity.x = speed * delta * 100
	position.x = clamp(position.x, 0, 720)

	moveRotation()
	move_and_slide()

func getDistanceToFinger() -> Vector2:
	return get_global_mouse_position() - position


func _on_invincibility_timeout() -> void:
	invincible = false
