extends Node2D

@export var bullet_scene: PackedScene
@export var time_between_shots: float = 0.15
@export var start_countdown: float = 0.0

var cooldown: float = start_countdown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cooldown -= delta
	
	if cooldown <= 0.0:
		cooldown = time_between_shots
	
		var bullet: Area2D = bullet_scene.instantiate()
		bullet.global_position = global_position
		
		get_tree().current_scene.add_child(bullet)
		
		$ShootSfx.pitch_scale = randf_range(0.5, 3.0)
		$ShootSfx.play()
