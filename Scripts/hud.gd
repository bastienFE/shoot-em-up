extends CanvasLayer

var score: float = 0.0

@onready var scoreLabel: Label = $ScoreLabel
@onready var deathScreen: Control = $DeathScreen
@onready var deathBox: VBoxContainer = $DeathScreen/DeathBox
@onready var deathScoreLabel: Label = $DeathScreen/DeathBox/DeathScoreLabel
@onready var damageFlash: ColorRect = $DamageFlash
@onready var lifeContainer: HBoxContainer = $LifeContainer

func _ready() -> void:
	GameManager.score_changed.connect(on_global_score_changed)
	GameManager.game_over.connect(display_game_over_screen)
	GameManager.player_move.connect(rotate_hud)
	GameManager.player_life_changed.connect(dreaming_in_red)

func on_global_score_changed(score: float) -> void:
	scoreLabel.text = "Score : " + str(int(score))

	var tween: Tween = create_tween()
	tween.tween_property(scoreLabel, "scale", Vector2(1.5, 1.5), 0.1)
	tween.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(scoreLabel, "scale", Vector2(1.0, 1.0), 0.5)

	self.score = score

func rotate_hud(speed: float) -> void:
	scoreLabel.rotation = sin(speed / 10000)

func display_game_over_screen() -> void:
	scoreLabel.hide()
	lifeContainer.hide()
	
	deathScoreLabel.text += str(int(score))

	deathScreen.show()
	
	var tween: Tween = create_tween()
	tween.tween_property(deathBox, "scale", Vector2(2.0, 2.0), 0.5)
	tween.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(deathBox, "scale", Vector2(1.0, 1.0), 1)
	

func dreaming_in_red(life: int) -> void:
	damageFlash.color = Color(1.0, 0.0, 0.0, 0.8)

	var tween: Tween = create_tween()
	tween.tween_property(damageFlash, "color", Color(1.0, 0.0, 0.0, 0.0), 1)
	tween.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	for i: int in lifeContainer.get_child_count():
		lifeContainer.get_child(i).visible = i < life


func _on_restart_pressed() -> void:
	GameManager.restart()

func _on_quit_pressed() -> void:
	get_tree().quit()
