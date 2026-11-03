extends Timer

@export var enemy_scene: PackedScene

func _on_timeout() -> void:
	var enemy: Area2D = enemy_scene.instantiate()
	enemy.global_position = Vector2(randf_range(0, 700), -60)
	get_tree().current_scene.add_child(enemy)
