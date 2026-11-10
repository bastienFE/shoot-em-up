extends Node

var score: float = 0.0

signal score_changed(score: float)
signal player_life_changed(life: int)
signal game_over
signal player_move(speed: float)


func add_score(score: float) -> void:
	self.score += score

	score_changed.emit(self.score)

func trigger_game_over() -> void:
	get_tree().paused = true
	game_over.emit()

func restart() -> void:
	self.score = 0.0

	get_tree().reload_current_scene()
	get_tree().paused = false
