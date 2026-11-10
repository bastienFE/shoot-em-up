extends Camera2D

var trauma: float = 0.0
var shake_strength: float = 10
var decay: float = 1.0

func _ready() -> void:
	GameManager.game_over.connect(add_trauma, 1)

func randomOffset() -> Vector2:
	return Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))

func randomRotation() -> float:
	var max_value: float = trauma / (2 * PI)
	return randf_range(-max_value, max_value)

func _process(delta: float) -> void:
	shake_strength = trauma**2 * 100

	if shake_strength > 0:
		trauma = lerpf(trauma, 0, decay * delta)

		self.rotation = randomRotation()

		offset = randomOffset()

func add_trauma(value: float) -> void:
	if self.trauma <= 1.0:
		self.trauma += value
